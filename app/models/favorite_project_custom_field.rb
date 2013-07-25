class FavoriteProjectCustomField < ActiveRecord::Base
  unloadable

  serialize :favorite_fields
end