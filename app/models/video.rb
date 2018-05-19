class Video
  include Mongoid::Document
  field :file, type: String

  mount_uploader :file, ::VideoUploader

  embedded_in :user
end
