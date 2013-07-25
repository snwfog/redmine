class FavoriteProjectCustomField < ActiveRecord::Base
  unloadable

  # validates :custom_field_id, inclusion: { in: CustomField.project.collect(&:id) }
  # validates :custom_field_id, presence: :true
  # validates :user_id, presence: :true

  def self.fav(user_id, custom_field_id)
    self.find_by_user_id_and_custom_field_id(user_id, custom_field_id)
  end
end