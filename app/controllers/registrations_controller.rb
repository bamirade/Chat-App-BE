class RegistrationsController < ApplicationController
  skip_before_action :authenticate_user!

  def create
    user = User.new(user_params)

    if user.save
      UserMailer.confirmation_email(user).deliver_now
      render json: { user: user, response: 'User account created. Please check your email for confirmation!'}, status: :ok
    else
      render json: { error: user.errors.full_messages[0] }, status: :unprocessable_entity
    end
  end

  def user_reconfirm
    email = params[:user][:email].to_s.strip

    unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: { error: 'Invalid email format' }, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: email)

    if user
      if user.status
        render json: { error: 'User account is already confirmed' }, status: :unprocessable_entity
      else
        new_confirmation_token = SecureRandom.urlsafe_base64
        user.update_column(:confirmation_token, new_confirmation_token)
        UserMailer.confirmation_email(user).deliver_now
        render json: { message: 'Confirmation email resent. Please check your email.' }, status: :ok
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  def confirm_email
    user = User.find_by(confirmation_token: params[:token])

    if user && !user.status
      user.update_column(:status, true)
      user.update_column(:confirmation_token, nil)
      UserMailer.approval_email(user).deliver_now

      response.headers['Refresh'] = '5;url=http://localhost:5173/'
      render json: { message: "Email confirmed. Redirecting to login page..." }, status: :ok
    else
      render json: { error: "Invalid confirmation token" }, status: :unprocessable_entity
    end
  end

  def password_reset
    email = params[:user][:email].to_s.strip

    unless email =~ /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      render json: { error: 'Invalid email format' }, status: :unprocessable_entity
      return
    end

    user = User.find_by(email: email)

    if user
      if user.status
        new_password = SecureRandom.urlsafe_base64
        if user.update(password: new_password)
          UserMailer.password_reset(user, new_password).deliver_now
          render json: { message: 'Password reset, check your email for your new password!'}
        else
          render json: { error: 'Failed to reset password'}, status: :unprocessable_entity
        end
      else
        render json: { error: 'Please activate your account first!' }, status: :forbidden
      end
    else
      render json: { error: 'User not found' }, status: :not_found
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

end
