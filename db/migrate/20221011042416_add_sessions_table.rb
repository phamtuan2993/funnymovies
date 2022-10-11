class AddSessionsTable < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'uuid-ossp'

    create_table :sessions do |t|
      t.uuid :session_id, :null => false, default: 'uuid_generate_v4()'
      t.text :data
      t.references :user
      t.timestamps
    end

    add_index :sessions, :session_id, :unique => true
    add_index :sessions, [:user_id, :session_id]
  end
end
