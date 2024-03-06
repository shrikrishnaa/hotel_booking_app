class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :user, null: false, foreign_key: true
      t.references :hotel, null: false, foreign_key: true
      t.integer :rooms_count
      t.date :check_in
      t.date :check_out
      t.string :status

      t.timestamps
    end
  end
end
