class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :player_name
      t.integer :mines
      t.integer :rows
      t.integer :columns
      t.boolean :is_winner
      t.boolean :game_is_over

      t.timestamps
    end
  end
end
