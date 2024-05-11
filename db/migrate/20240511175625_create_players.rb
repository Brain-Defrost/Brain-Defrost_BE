class CreatePlayers < ActiveRecord::Migration[7.1]
  def change
    create_table :players do |t|
      t.string :display_name
      t.integer :answers_correct, default: 0
      t.integer :answers_incorrect, default: 0
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
