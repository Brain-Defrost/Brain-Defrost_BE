class StatSenderJob
  include Sidekiq::Job

  def perform(email, json_stat)
    hash_stat = JSON.parse(json_stat, symbolize_names: true)
    stat = Stat.find(hash_stat[:id])
    Api::V1::StatMailer.send_stat_email(email, stat).deliver_now
  end
end
