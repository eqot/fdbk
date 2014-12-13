class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all.page(params[:page])
  end

  def show
    @feedback = Feedback.find(params[:id])
  end

  def new
    if user_signed_in?
      @feedback = current_user.feedbacks.build
    else
      @feedback = Feedback.new
    end
  end

  def create
    if user_signed_in?
      @feedback = current_user.feedbacks.build(feedback_params)
    else
      @feedback = Feedback.new(feedback_params)
    end

    if @feedback.save
      redirect_to @feedback, notice: 'Created'
    else
      render :new
    end
  end

  def edit
    @feedback = Feedback.find(params[:id])
  end

  def update
    @feedback = current_user.feedbacks.find(params[:id])
    if @feedback.update(feedback_params)
      redirect_to @feedback, notice: 'Updated'
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
