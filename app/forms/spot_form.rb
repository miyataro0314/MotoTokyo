class SpotForm
  include ActiveModel::Model

  attr_accessor :spot, :difficulty, :comment

  delegate :name, :parking, :parking_limitation, :category, to: :spot
  delegate :level, to: :difficulty
  delegate :content, to: :comment

  def initialize(spot:, difficulty:, comment:)
    @spot = spot
    @difficulty = difficulty
    @comment = comment
  end

  def update(params)
    @params = params
    update_spot_with_associations
  end

  private

  def update_spot_with_associations
    ActiveRecord::Base.transaction do
      raise ActiveRecord::Rollback unless update_spot_and_diffculty && save_or_update_comment
    end
    true
  rescue ActiveRecord::Rollback
    false
  end

  def update_spot_and_diffculty
    @spot.update(spot_params) && @difficulty.update(difficulty_params)
  end

  def save_or_update_comment
    return @comment.destroy if comment_params[:content].blank?

    if @comment.persisted?
      @comment.update(comment_params)
    else
      @comment.content = comment_params[:content]
      @comment.save
    end
  end

  def permitted_params
    @params.require(:spot_form).permit(%i[name parking parking_limitation category level content])
  end

  def spot_params
    params = permitted_params.slice(:name, :parking, :parking_limitation, :category)
    params.merge({ parking_limitation: nil }) if params[:parking] == 'nothing' || params[:parking] == 'unknown'
    params
  end

  def difficulty_params
    permitted_params.slice(:level)
  end

  def comment_params
    permitted_params.slice(:content)
  end
end
