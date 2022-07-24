class CreateFlights < ActiveRecord::Migration[6.1]
  def change
    create_table :flights do |t|
      t.string :name, null: false
      t.integer :no_of_seats
      t.integer :base_price, null: false
      t.timestamp :departs_at, null: false
      t.timestamp :arrives_at, null: false

      t.belongs_to :company, index: true, foreign_key: true

      t.timestamps
    end
  end
end
