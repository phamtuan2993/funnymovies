class AddEmbeddedIdToMovie < ActiveRecord::Migration[6.1]
  def change
    add_column :movies, :embedded_id, :string
  end
end
