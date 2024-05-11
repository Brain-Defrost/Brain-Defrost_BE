class CreateGames < ActiveRecord::Migration[7.1]
  def change
    create_table :games do |t|
      t.string :topic
      t.integer :number_of_questions
      t.integer :time_limit, default: 30
      t.integer :number_of_players
      t.boolean :started, default: false
      t.string :link

      t.timestamps
    end
  end
end
