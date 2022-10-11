class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.references :shared_by, null: false, references: :users
      t.text :url, null: false
      t.text :title
      t.text :description
      t.timestamps
    end
  end
end
