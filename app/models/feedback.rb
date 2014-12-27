class CarrierStringIO < StringIO
  def original_filename
    "image.png"
  end

  def content_type
    "image/png"
  end
end

class Feedback < ActiveRecord::Base
  belongs_to :user

  has_many :tag_feedbacks
  has_many :tags, through: :tag_feedbacks

  mount_uploader :file, FileUploader

  validates :comment, presence: true

  attr_accessor :tag_labels
  attr_accessor :file_data

  def user?(user)
    return false unless user
    user_id == user.id
  end

  def tagged?(tag)
    return false unless tag
    tag_feedbacks.find_by(tag_id: tag.id)
  end

  def add!(tag)
    tag_feedbacks.find_or_create_by!(tag_id: tag.id)
  end

  def file_data=(data)
    self.file = CarrierStringIO.new(Base64.decode64(data['data:image/png;base64,'.length .. -1]))
  end
end
