class FavoriteProjectCustomField < ActiveRecord::Base
  unloadable

  validates :custom_field_id, inclusion: { in: CustomField.project.collect(&:id) }
  validates :custom_field_id, presence: :true
  validates :user_id, presence: :true
end