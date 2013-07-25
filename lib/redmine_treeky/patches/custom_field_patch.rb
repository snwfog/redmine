require_dependency 'custom_field'

module RedmineTreeky
  module Patches
    module CustomFieldPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        # base.send(:include, InstanceMethods)

      end

      module ClassMethods
        def custom_field(field)
          CustomField.where("type = ?", field);
        end

        def project
          custom_field :ProjectCustomField
        end
      end
    end
  end
end

unless CustomField.included_modules.include?(RedmineTreeky::Patches::CustomFieldPatch)
  CustomField.send(:include, RedmineTreeky::Patches::CustomFieldPatch)
end
