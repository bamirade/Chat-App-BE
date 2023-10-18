class UserMailer < ApplicationMailer
  def confirmation_email(user)
    @user = user
    mail(to: @user.email, subject: 'Confirm Your Email')
  end

  def approval_email(user)
    @user = user
    mail(to: @user.email, subject: 'Account Approved')
  end

  def password_reset(user, new_password)
    @user = user
    @new_password = new_password
    mail(to: @user.email, subject: 'Password has been Reset')
  end
end
