class StatSenderJob
  include Sidekiq::Job

  def perform(email, stat)
    UserNotifierMailer.send_stat_email(email, stat).deliver_now
  end
end
