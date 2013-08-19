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

          has_and_belongs_to_many :favorite_project_custom_fields,
              class_name: "CustomField", join_table: "favorite_project_custom_fields",
              foreign_key: "user_id", association_foreign_key: "custom_field_id"

          has_one :favorite_project_extra_column
        end
      end

      module ClassMethods
      end

      module InstanceMethods
        def favorite?(project)
          self.favorite_project_ids.include?(project.id)
        end
      end
    end
  end
end

unless User.included_modules.include?(RedmineTreeky::Patches::UserPatch)
  User.send(:include, RedmineTreeky::Patches::UserPatch)
end
