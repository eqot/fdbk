class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all
  end

  def show
    @feedback = Feedback.find_by(params[:id])
  end
end
