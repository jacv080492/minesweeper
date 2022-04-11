class RenameGameIsOverToIsGameOverGames < ActiveRecord::Migration[7.0]
  def change
    rename_column :games, :game_is_over, :is_game_over
  end
end
