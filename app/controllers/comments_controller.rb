class CommentsController < ApplicationController
  before_action :set_spot
  skip_before_action :authenticate_user!, only: :index

  def index
    @comments = @spot.comments.includes(user: :profile)
  end

  def new
    @comment = Comment.new
  end

  def edit
    @comment = current_user.comment_for(@spot)
  end

  def create
    @comment = build_comment_from_params
    if @comment.save
      redirect_to spot_path(@spot, from: params[:from]), notice: I18n.t('flash.comments.create.notice')
    else
      errors = @comment.errors[:content].join(' ')
      redirect_to spot_path(@spot, from: params[:from]), alert: errors
    end
  end

  def update
    @comment = current_user.comment_for(@spot)

    if @comment.update(comment_params)
      redirect_to spot_path(@spot, from: params[:from]), notice: I18n.t('flash.comments.update.notice')
    else
      errors = @comment.errors[:content].join(' ')
      redirect_to spot_path(@spot, from: params[:from]), alert: errors
    end
  end

  def destroy
    @comment = current_user.comment_for(@spot)
    if @comment.destroy
      redirect_to spot_path(@spot, from: params[:from]), notice: I18n.t('flash.comments.destroy.notice')
    else
      redirect_to spot_path(@spot, from: params[:from]), alert: I18n.t('flash.comments.destroy.alert')
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def build_comment_from_params
    Comment.new(
      user_id: current_user.id,
      spot_id: params[:spot_id],
      content: comment_params[:content]
    )
  end
end
