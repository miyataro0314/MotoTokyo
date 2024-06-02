class DifficultiesController < ApplicationController
  skip_before_action :authenticate_user!, only: :show
  before_action :set_spot, only: %i[show create update]

  def show
    if user_signed_in?
      @difficulty = Difficulty.find_or_initialize_by(user_id: current_user.id, spot_id: @spot.id)
    else
      redirect_to spot_path(@spot, from: params[:from]), alert: '続行するにはログインまたはユーザー登録が必要です。'
    end
  end

  def create
    difficulty = Difficulty.new(
      user_id: current_user.id,
      spot_id: @spot.id,
      level: difficulty_params[:level]
    )

    if difficulty.update(difficulty_params)
      flash[:notice] = '行きやすさ投票を完了しました'
    else
      flash[:alert] = 'エラーが発生し、投票が完了しませんでした'
    end
    redirect_to spot_path(@spot)
  end

  def update
    difficulty = current_user.difficulty_for(@spot)

    if difficulty.update(difficulty_params)
      flash[:notice] = '行きやすさ投票を完了しました'
    else
      flash[:alert] = 'エラーが発生し、投票が完了しませんでした'
    end
    redirect_to spot_path(@spot)
  end

  private

  def difficulty_params
    params.require(:difficulty).permit(:level)
  end

  def set_spot
    @spot = Spot.find(params[:spot_id])
  end
end
