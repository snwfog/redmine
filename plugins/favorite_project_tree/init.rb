
Redmine::Plugin.register :favorite_project_tree do
  name 'Favorite Project Tree plugin'
  author 'Charles Yang'
  description 'This Redmine plugin is a merge of favorite projects and tree view.'
  version '0.0.1'

end

require 'favorite_project_tree/patches/application_helper_patch'
require 'favorite_project_tree/patches/projects_controller_patch'
require 'favorite_project_tree/patches/projects_helper_patch'






