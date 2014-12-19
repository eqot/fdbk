class Feedback < ActiveRecord::Base
  belongs_to :user

  has_many :tag_feedbacks
  has_many :tags, through: :tag_feedbacks

  def user?(user)
    return false unless user
    user_id == user.id
  end

  def add!(tag)
    tag_feedbacks.create!(tag_id: tag.id)
  end
end
