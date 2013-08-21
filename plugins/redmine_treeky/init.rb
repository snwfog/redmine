require 'redmine'

if Rails::VERSION::MAJOR < 3
  require 'dispatcher'
  object_to_prepare = Dispatcher
else
  object_to_prepare = Rails.configuration
  # if redmine plugins were railties:
  # object_to_prepare = config
end

object_to_prepare.to_prepare do
  require_dependency 'redmine_treeky/patches/acts_as_customizable_patch'
  require_dependency 'redmine_treeky/patches/custom_fields_helper_patch'
  require_dependency 'redmine_treeky/patches/custom_field_patch'
  require_dependency 'redmine_treeky/patches/projects_helper_patch'
  require_dependency 'redmine_treeky/patches/projects_controller_patch'
  require_dependency 'redmine_treeky/patches/project_patch'
  require_dependency 'redmine_treeky/patches/user_patch'
end



Redmine::Plugin.register :redmine_treeky do
  name  'Redmine Treeky'
  author 'Charles Yang'
  description 'Series of custom features, merges and good stuffs.'
  version '0.0.1'
end

class RedmineTreekyViewListener < Redmine::Hook::ViewListener
  # Adds javascript and stylesheet tags
  def view_layouts_base_html_head(context)
    javascript_include_tag('favorite_project_script', :plugin => :redmine_treeky) +
        stylesheet_link_tag('projects_tree_view', :plugin => :redmine_treeky)
  end
end
