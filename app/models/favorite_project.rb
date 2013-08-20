class FavoriteProject < ActiveRecord::Base
  unloadable
  validates_uniqueness_of :user_id, scope: :project_id
  validates_presence_of :user_id, :project_id

  attr_accessible :project_id
  after_initialize :set_user_id

  def set_user_id
    self.user_id ||= User.current.id
  end
end
