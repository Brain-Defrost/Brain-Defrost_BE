class StatSenderJob
  include Sidekiq::Job

  def perform(email, stat_id)
    stat = Stat.find(stat_id)
    Api::V1::StatMailer.send_stat_email(email, stat).deliver_now
  end
end
