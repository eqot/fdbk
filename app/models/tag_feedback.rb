class TagFeedback < ActiveRecord::Base
  belongs_to :tag
  belongs_to :feedback
end
