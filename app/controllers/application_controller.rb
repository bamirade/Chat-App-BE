class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate_user!

  private

  def authenticate_user!
    render_unauthorized unless current_user
  end

  def current_user
    return @current_user if defined?(@current_user)

    token = authenticate_with_http_token { |token| token }
    return nil unless token

    payload = AuthHelper.decode_token(token)
    @current_user = User.find_by(id: payload['user_id']) if payload.present?
  end

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

end
