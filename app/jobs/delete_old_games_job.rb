class DeleteOldGamesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Game.where("created_at < ?", 1.hour.ago).destroy_all
  end
end
