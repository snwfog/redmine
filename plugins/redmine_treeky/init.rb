
Redmine::Plugin.register :redmine_treeky do
  name 'Treeky'
  author 'Charles Yang'
  description 'This Redmine plugin is a merge of favorite projects and tree view.'
  version '0.0.1'

end

require 'redmine_treeky/patches/application_helper_patch'
require 'redmine_treeky/patches/projects_controller_patch'
require 'redmine_treeky/patches/projects_helper_patch'
require 'redmine_treeky/patches/projects_helper'

class TreekyViewListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    javascript_include_tag('redmine_treeky', plugin: :redmine_treeky)
    stylesheet_link_tag( 'redmine_treeky', plugin: :redmine_treeky)
  end
end






