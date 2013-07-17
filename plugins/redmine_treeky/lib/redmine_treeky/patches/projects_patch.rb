module RedmineTreeky
  module Patches
    module ProjectPatch
      def self.include(base)
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          has_many_and_belongs_to_many :watch_users, :class_name => 'User',
              :join_table => 'favorite_projects', :foreign_key => 'user_id'

        end
      end
    end
  end
end

unless Project.included_modules.include?(RedmineTreeky::Patches::ProjectPatch)
  Project.send(:include, RedmineTreeky::Patches::ProjectPatch)
end
