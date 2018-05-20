class VideoTrimmer
  attr_reader :video, :ffmpeg_result_movie
  def initialize(video)
    @video = video
  end

  def call
    validate!
    trim!
    set_result
    set_result_duration
    @video.complete!
  end

  private

  def validate!
    message = Message.finish_less_than_start unless @video.start_position < @video.finish_position
    message = Message.finish_exceeds_duration unless @video.finish_position < video_duration(ffmpeg_source_movie)
    if message
      @video.fail!
      raise ExceptionHandler::WrongTiming, message
    end
  end

  def trim!
    @ffmpeg_result_movie =
        ffmpeg_source_movie.transcode(@video.result_file_path, [
          '-ss', @video.start_position.to_s,
          '-to', @video.finish_position.to_s,
          '-strict', '-2'
        ])
  rescue Exception => e
    @video.fail!
    raise ExceptionHandler::EncodingError, e.message
  end

  def set_result
    @video.update_attribute(:result, ffmpeg_result_movie&.path&.sub(Rails.public_path.to_s,''))
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