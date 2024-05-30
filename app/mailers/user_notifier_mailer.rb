class UserNotifierMailer < ApplicationMailer
  def send_stat_email(email, stat)
    @stat = stat
    mail(to: email, subject: 'Your Statistics Report')
  end
end
