class FavoriteProjectCustomField < ActiveRecord::Base
  unloadable

  # validates :custom_field_id, inclusion: { in: CustomField.project.collect(&:id) }
  # validates :custom_field_id, presence: :true
  # validates :user_id, presence: :true

  def self.fav(user_id, custom_field_id)
    self.find_by_user_id_and_custom_field_id(user_id, custom_field_id)
  end

  def self.favorites(user_id, custom_field_ids = User.current.favorite_project_custom_field_ids)
    FavoriteProjectCustomField.where("custom_field_id IN (?) AND user_id = ?", custom_field_ids, user_id)
  end
end