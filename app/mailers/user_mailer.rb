class UserMailer < ActionMailer::Base
  def account_created(user, tmp_pass)
    @user = User.find(user)
    @plain_password = tmp_pass
    mail :to => @user.email,
         :from => "#{Constants::NAME} <info@hanamech.com>",
         :subject => "#{Constants::NAME} - Account Created"
  end
end