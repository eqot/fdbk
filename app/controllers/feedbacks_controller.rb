class FeedbacksController < ApplicationController
  def index
    @feedbacks = Feedback.all.order('created_at desc').page(params[:page])
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

    if params[:u].present?
      @feedback.url = params[:u]
    end

    if params[:t].present?
      @feedback.tag_labels = params[:t]
    end
  end

  def create
    if user_signed_in?
      @feedback = current_user.feedbacks.build(feedback_params)
    else
      @feedback = Feedback.new(feedback_params)
    end

    if @feedback.save
      save_tags
      redirect_to @feedback, notice: 'Created'
    else
      render :new
    end
  end

  def edit
    @feedback = Feedback.find(params[:id])

    tags = @feedback.tags.collect(&:label)
    @feedback.tag_labels = tags.join(', ')
  end

  def update
    @feedback = current_user.feedbacks.find(params[:id])
    if @feedback.update(feedback_params)
      save_tags
      redirect_to @feedback, notice: 'Updated'
    else
      render :new
    end
  end

  private

  def feedback_params
    params.require(:feedback).permit(
      :comment, :url, :tag_labels
    )
  end

  def save_tags
    tags = params[:feedback][:tag_labels].split(',')
    tags.each do |label|
      tag = Tag.find_or_create_by(label: label.strip)
      tag.save!

      @feedback.add!(tag)
    end
  end
end
