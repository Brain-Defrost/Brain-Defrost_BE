class CreateStats < ActiveRecord::Migration[7.1]
  def change
    create_table :stats do |t|
      t.float :avg_correct_answers, default: 0
      t.references :game, null: false, foreign_key: true

      t.timestamps
    end
  end
end
