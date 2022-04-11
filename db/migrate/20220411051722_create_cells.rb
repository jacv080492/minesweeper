class CreateCells < ActiveRecord::Migration[7.0]
  def change
    create_table :cells do |t|
      t.integer :x_axis
      t.integer :y_axis
      t.boolean :is_mined
      t.boolean :is_exposed
      t.boolean :is_flagged

      t.timestamps
    end
  end
end
