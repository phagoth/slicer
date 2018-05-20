class Video
  include Mongoid::Document
  field :source, type: String
  field :result, type: String
  field :result_duration, type: Integer
  field :start_position, type: Integer
  field :finish_position, type: Integer

  mount_uploader :source, ::VideoUploader

  embedded_in :user

  def source_file_path
    source.path
  end

  def result_file_path
    Rails.public_path.join(source.store_dir,"#{source.file.basename}_trimmed.#{source.file.extension}").to_s
  end
end
