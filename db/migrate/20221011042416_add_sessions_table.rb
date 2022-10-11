class AddSessionsTable < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'uuid-ossp'

    create_table :sessions do |t|
      t.string :token, limit: 255, :null => false
      t.references :user
      t.timestamps
    end

    add_index :sessions, :token, :unique => true
    add_index :sessions, [:user_id, :token]
  end
end
