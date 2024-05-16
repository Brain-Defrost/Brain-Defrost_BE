class AddQuestionsCorrectToPlayers < ActiveRecord::Migration[7.1]
  def change
    add_column :players, :questions_correct, :string, array: true, default: []
  end
end
