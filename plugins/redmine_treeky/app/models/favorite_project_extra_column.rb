class FavoriteProjectExtraColumn < ActiveRecord::Base
  unloadable

  attr_accessible :description, :created_on
end
