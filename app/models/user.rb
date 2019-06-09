class User < ApplicationRecord
  has_many :tokens
  has_many :messages
  mount_uploader :image, UserImageUploader
end
