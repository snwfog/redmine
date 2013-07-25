class CreateFavoriteProjectCustomFields < ActiveRecord::Migration
  def up
    create_table :favorite_project_custom_fields do |t|
      t.integer :user_id
      t.integer :favorite_fields
    end
  end

  def down
    drop_table :favorite_project_custom_fields
  end

end
