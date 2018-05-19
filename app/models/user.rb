class User
  include Mongoid::Document
  include ActiveModel::SecurePassword

  field :email, type: String
  field :password_digest, type: String

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password_confirmation, presence: true, on: :create

  embeds_many :videos
end
