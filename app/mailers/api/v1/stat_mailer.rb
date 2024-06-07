class Api::V1::StatMailer < ApplicationMailer
  
  def send_stat_email(email, stat)
    @stat = stat
    mail(to: email, subject: 'Your Brain Freeze Statistics Report')
  end
end
