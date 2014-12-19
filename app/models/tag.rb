class Tag < ActiveRecord::Base
  has_many :tag_feedbacks
  has_many :feedbacks, through: :tag_feedbacks
end
