require_dependency 'project'

module RedmineTreeky
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          has_and_belongs_to_many :watch_users, :class_name => 'User',
              :join_table => 'favorite_projects', :foreign_key => 'project_id',
              :association_foreign_key => 'user_id'

        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end

    end

  end
end

unless Project.included_modules.include?(RedmineTreeky::Patches::ProjectPatch)
  Project.send(:include, RedmineTreeky::Patches::ProjectPatch)
end