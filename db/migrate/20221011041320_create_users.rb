class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :email, limit: 255, null: false
      t.string :encrypted_password, limit: 255, null: false
      t.timestamps
    end

    add_index :users, :email, :unique => true
  end
end
