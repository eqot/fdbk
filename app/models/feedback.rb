class Feedback < ActiveRecord::Base
  belongs_to :user

  def user?(user)
    return false unless user
    user_id == user.id
  end
end
