class SpotRegistrationsController < ApplicationController
  def step1
    @spot = Spot.new(name: session[:name])
  end

  def step2
    @spot = Spot.new(
      parking: session[:parking],
      parking_limitation: session[:parking_limitation]
    )
  end

  def step3
    set_session_parking
    set_session_parking_limitation

    if params[:next]
      @spot = Spot.new(category: session[:category])
      @difficulty = Difficulty.new(level: session[:difficulty_level])
    elsif params[:back]
      @spot = Spot.new(name: session[:name])
      render 'step1'
    end
  end

  def step4
    unless params[:from_confirmation]
      set_session_difficulty_level
      set_session_category
    end

    if params[:next] || params[:from_confirmation]
      @comment = Comment.new(content: session[:comment_content])
    elsif params[:back]
      @spot = Spot.new(
        parking: session[:parking],
        parking_limitation: session[:parking_limitation]
      )
      render 'step2'
    end
  end

  def confirmation
    set_session_comment_content

    return unless params[:back]

    @spot = Spot.new(category: session[:category])
    @difficulty = Difficulty.new(level: session[:difficulty_level])
    render 'step3'
  end

  def success
    @spot = Spot.find(params[:id])
    @count = Spot.all.count
    post_to_x
  end

  def failure; end

  private

  def spot_params
    params.require(:spot).permit(%i[parking parking_limitation category])
  end

  def difficulty_params
    params.require(:difficulty).permit(:level)
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def set_session_parking
    session[:parking] = spot_params[:parking]
  end

  def set_session_parking_limitation
    if session[:parking] == 'nothing' || session[:parking] == 'unknown'
      session.delete(:parking_limitation)
    else
      session[:parking_limitation] = spot_params[:parking_limitation]
    end
  end

  def set_session_difficulty_level
    session[:difficulty_level] = difficulty_params[:level]
  end

  def set_session_category
    session[:category] = spot_params[:category]
  end

  def set_session_comment_content
    session[:comment_content] = comment_params[:content]
  end

  def post_to_x
    require 'x'

    message = "新しいスポットが追加されました: #{@spot.name}"
    x_credentials = {
      api_key: Rails.application.credentials.x[:api_key],
      api_key_secret: Rails.application.credentials.x[:api_key_secret],
      access_token: Rails.application.credentials.x[:access_token],
      access_token_secret: Rails.application.credentials.x[:access_token_secret]
    }
    x_client = X::Client.new(**x_credentials)
    post = x_client.post("tweets", '{"text":"Hello, World! (from @gem)"}')
  end
end
