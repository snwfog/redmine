
Redmine::Plugin.register :redmine_treeky do
  name 'Treeky'
  author 'Charles Yang'
  description 'This Redmine plugin is a merge of favorite projects and tree view.'
  version '0.0.1'

end

require 'treeky/patches/application_helper_patch'
require 'treeky/patches/projects_controller_patch'
require 'treeky/patches/projects_helper_patch'

#class TreekyViewListener < Redmine::Hook::ViewListener
#  def view_layouts_base_html_head(context)
#    javascript_include_tag 'treeky', plugin: :treeky
#    stylesheet_link_tag 'treeky', plugin: :treeky
#  end
#end






