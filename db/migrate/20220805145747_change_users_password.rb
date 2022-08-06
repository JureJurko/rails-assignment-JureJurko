class ChangeUsersPassword < ActiveRecord::Migration[6.1]
  def up
    change_table :users do |t|
      t.change :password_digest, :string
    end
  end

  def down
    change_table :users do |t|
      t.change :password_digest, :string
    end
  end
end
