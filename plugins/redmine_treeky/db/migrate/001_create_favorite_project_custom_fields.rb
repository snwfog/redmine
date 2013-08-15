class CreateFavoriteProjectCustomFields < ActiveRecord::Migration
  def self.up
    create_table :favorite_project_custom_fields, :id => false do |t|
      t.column :user_id, :integer, :null => false
      t.column :custom_field_id, :integer, :null => false
    end

    add_index :favorite_project_custom_fields, [:user_id, :custom_field_id],
        name: :user_project_custom_fields
  end

  def self.down
    drop_table :favorite_project_custom_fields
  end
end
