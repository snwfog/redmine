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
  require_dependency 'redmine_enh_drag_n_drop_custom_field/patches/custom_fields_controller_patch'
end

Redmine::Plugin.register :redmine_enh_drag_n_drop_custom_field do
  name 'Redmine Enh Drag and Drop Custom Field plugin'
  author 'Charles Yang'
  description 'This is an enhancement plugin that let drag and drop of the custom label field table rows'
  version '0.0.1'
end

class RedmineEnhDragNDropCustomFieldViewListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    javascript_include_tag('drag_n_drop', plugin: :redmine_enh_drag_n_drop_custom_field) +
    stylesheet_link_tag('drag_n_drop', plugin: :redmine_enh_drag_n_drop_custom_field)
  end
end