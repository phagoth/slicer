class Video
  include Mongoid::Document
  # include GlobalID::Identification
  include AASM
  field :source, type: String
  field :result, type: String
  field :result_duration, type: Integer
  field :start_position, type: Integer
  field :finish_position, type: Integer
  field :status, type: String

  mount_uploader :source, ::VideoUploader

  embedded_in :user

  aasm column: 'status' do
    state :enqueued, initial: true
    state :processing
    state :done
    state :failed

    event :process, after: :start_video_processing do
      transitions from: :enqueued, to: :processing
    end

    event :complete do
      transitions from: :processing, to: :done
    end

    event :fail do
      transitions from: :processing, to: :failed
    end

    event :reprocess do
      transitions from: :failed, to: :enqueued
    end
  end

  def source_file_path
    source.path
  end

  def result_file_path
    Rails.public_path.join(source.store_dir,"#{source.file.basename}_trimmed.#{source.file.extension}").to_s
  end

  private

  def start_video_processing
    VideoTrimmerJob.perform_later(_parent, id.to_s)
  end
end
