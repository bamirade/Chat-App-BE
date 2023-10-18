class SessionsController < ApplicationController
  skip_before_action :authenticate_user!

  def login
    user = User.find_by(username: params[:user][:username])

    if user
      if user.authenticate(params[:user][:password])
        if user.status
          token = AuthHelper.generate_token(user.id)
          user_data = { token: token, username: user.username, email: user.email, status: user.status, id: user.id }
          render json: user_data, status: :ok
        else
          render json: { error: 'User account is currently inactive' }, status: :forbidden
        end
      else
        render json: { error: 'Incorrect Password' }, status: :unauthorized
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end
end
