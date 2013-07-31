class CreateFavoriteProjectExtraColumns < ActiveRecord::Migration
  def change
    create_table :favorite_project_extra_columns do |t|
      t.column :user_id, :integer
      t.column :description, :boolean
      t.column :created_on, :boolean
      t.timestamps
    end
  end
end
