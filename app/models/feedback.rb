class Feedback < ActiveRecord::Base
  belongs_to :user

  has_many :tag_feedbacks
  has_many :tags, through: :tag_feedbacks

  mount_uploader :file, FileUploader

  validates :comment, presence: true

  attr_accessor :tag_labels

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
end
