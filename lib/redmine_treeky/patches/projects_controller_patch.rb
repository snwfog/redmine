require_dependency 'projects_controller'

module RedmineTreeky
  module Patches
    module ProjectsControllerPatch
      def self.included(base) # :nodoc:

        base.send(:include, InstanceMethods)
        base.class_eval do
          unloadable

          alias_method :redmine_index, :index
          alias_method :index,:index_with_custom_values
        end
      end

      module InstanceMethods
        def index_with_custom_values
          respond_to do |format|
            format.html {
              scope = Project.includes(:custom_values)
              unless params[:closed]
                scope = scope.active
              end
              @projects = scope.order('lft').all
            }
            format.api  {
              @offset, @limit = api_offset_and_limit
              @project_count = Project.visible.count
              @projects = Project.visible.offset(@offset).limit(@limit).order('lft').all
            }
            format.atom {
              projects = Project.visible.order('created_on DESC').limit(Setting.feeds_limit.to_i).all
              render_feed(projects, :title => "#{Setting.app_title}: #{l(:label_project_latest)}")
            }
          end
        end
      end # EO InstanceMethods

    end # EO ProjectsControllerPatch
  end # EO Patches
end # EO RedmineTreeky

unless ProjectsController.included_modules.include?(RedmineTreeky::Patches::ProjectsControllerPatch)
  ProjectsController.send(:include, RedmineTreeky::Patches::ProjectsControllerPatch)
end
