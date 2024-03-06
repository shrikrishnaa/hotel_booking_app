class CreateHotels < ActiveRecord::Migration[7.0]
  def change
    create_table :hotels do |t|
      t.string :name
      t.string :location
      t.integer :rooms_count

      t.timestamps
    end
  end
end
