class AddUniqueIndexToToken < ActiveRecord::Migration[6.1]
  def change
    add_index :users, :token, unique: true
  end
end