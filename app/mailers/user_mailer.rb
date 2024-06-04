class UserMailer < ApplicationMailer
  def send_stat_email(email, stat)
    @stat = stat
    mail(to: email, subject: 'Your Statistics Report')
  end

  def create_invite(sender_email, recipient_email, sent_at)
    @sender_email = sender_email
    @recipient_email = recipient_email
    @sent_at = sent_at

    mail(to: @recipient_email, from: @sender_email, subject: "You have been invited by #{@sender_email}")
  end
end
