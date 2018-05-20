class VideoTrimmer
  attr_reader :video, :start, :finish, :ffmpeg_result_movie
  def initialize(video, start, finish)
    @video = video
    @start = start
    @finish = finish
  end

  def call
    validate!
    trim!
    set_result
    set_result_duration
  end

  private

  def validate!
    message = Message.finish_less_than_start unless @start < @finish
    message = Message.finish_exceeds_duration unless @finish < video_duration(ffmpeg_source_movie)
    raise ExceptionHandler::WrongTiming, message if message
  end

  def trim!
    @ffmpeg_result_movie =
        ffmpeg_source_movie.transcode(@video.result_file_path, [
          '-ss', @start.to_s,
          '-to', @finish.to_s,
          '-strict', '-2'
        ])
  end

  def set_result
    @video.update_attribute(:result, ffmpeg_result_movie.path)
  end

  def set_result_duration
    @video.update_attribute(:result_duration, video_duration(ffmpeg_result_movie))
  end

  def ffmpeg_movie(file_path)
    FFMPEG::Movie.new(file_path)
  end

  def ffmpeg_source_movie
    @ffmpeg_source_movie ||= ffmpeg_movie(@video.source_file_path)
  end

  def video_duration(movie)
    movie.duration
  end

end