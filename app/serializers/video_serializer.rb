class VideoSerializer < ActiveModel::Serializer
  attributes :id, :result, :result_duration, :status

  def id
    object.id.to_s
  end
end
