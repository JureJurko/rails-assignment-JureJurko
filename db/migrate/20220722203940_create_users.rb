class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.string :email, null: false, index: { unique: true }

      t.timestamps
    end
  end

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
