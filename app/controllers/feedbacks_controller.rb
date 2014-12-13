class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all.page(params[:page])
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def new
    @feedback = current_user.feedbacks.build
  end

  def create
    @feedback = current_user.feedbacks.build(feedback_params)
    if @feedback.save
      redirect_to @feedback, notice: 'Created'
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :title, :description
    )
  end
end
