class CommentsController < ApplicationController
  before_action :set_spot
  skip_before_action :authenticate_user!, only: :index

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new(
      user_id: current_user.id,
      spot_id: params[:spot_id],
      content: comment_params[:content]
    )
    if @comment.save
      redirect_to spot_path(@spot), notice: 'おすすめポイントを投稿しました'
    else
      errors = @comment.errors[:content].join(' ')
      redirect_to spot_path(@spot), alert: errors
    end
  end

  def edit
    @comment = current_user.comment_for(@spot)
  end

  def update
    @comment = current_user.comment_for(@spot)

    if @comment.update(comment_params)
      redirect_to spot_path(@spot), notice: 'おすすめポイントを更新しました'
    else
      errors = @comment.errors[:content].join(' ')
      redirect_to spot_path(@spot), alert: errors
    end
  end

  def index
    @comments = @spot.comments.includes(user: :profile)
  end

  def destroy
    @comment = current_user.comment_for(@spot)
    if @comment.destroy
      redirect_to spot_path(@spot), notice: 'おすすめポイントを削除しました'
    else
      redirect_to spot_path(@spot), alert: 'おすすめポイントの削除に失敗しました'
    end
  end

  private

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
