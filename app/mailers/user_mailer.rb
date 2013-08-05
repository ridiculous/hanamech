class UserMailer < ActionMailer::Base
  def account_created(user, tmp_pass)
    @user = User.find(user)
    @plain_password = tmp_pass
    mail :to => @user.email,
         :from => 'Hana Mechanical <info@hanamech.com>',
         :subject => "Hana Mechanical - Account Created"
  end
end