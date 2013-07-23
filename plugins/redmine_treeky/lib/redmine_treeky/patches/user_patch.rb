require_dependency 'user'

module RedmineTreeky
  module Patches
    module UserPatch
      def self.included(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          has_and_belongs_to_many :favorite_projects, :class_name => 'Project',
              :join_table => 'favorite_projects', :foreign_key => 'user_id',
              :association_foreign_key => 'project_id'

        end
      end

      module ClassMethods
      end

      module InstanceMethods
      end

    end
  end
end

unless User.included_modules.include?(RedmineTreeky::Patches::UserPatch)
  User.send(:include, RedmineTreeky::Patches::UserPatch)
end
