class VideoTrimmerJob < ApplicationJob
  queue_as :video_trimmer

  def perform(user, video_id)
    video = user.videos.find(video_id)
    VideoTrimmer.new(video).call if video
  end
end
