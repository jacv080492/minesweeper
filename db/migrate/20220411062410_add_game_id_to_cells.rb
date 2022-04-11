class AddGameIdToCells < ActiveRecord::Migration[7.0]
  def change
    add_reference :cells, :game, null: false, foreign_key: true
  end
end
