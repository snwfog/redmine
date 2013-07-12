require 'redmine'

# Patches to the Redmine core.
require 'redmine_treeky/patches/projects_helper_patch'

Redmine::Plugin.register :redmine_treeky do
  name  'plugin'
  author 'Charles Yang'
  description 'Series of custom features, merges and good stuffs.'
  version '0.0.1'
end

class RedmineTreekyViewListener < Redmine::Hook::ViewListener

  # Adds javascript and stylesheet tags
  def view_layouts_base_html_head(context)
    javascript_include_tag('projects_tree_view', :plugin => :redmine_treeky) +
    stylesheet_link_tag('projects_tree_view', :plugin => :redmine_treeky)
  end
  
end
