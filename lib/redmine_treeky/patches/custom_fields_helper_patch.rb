require_dependency 'custom_fields_helper'

module RedmineTreeky
  module Patches
    module CustomFieldsHelperPatch
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def show_field(field)
          return "" unless field[:value]
          format_value(field[:value].value, field[:field].field_format)
        end
      end
    end
  end
end

unless CustomFieldsHelper.included_modules.include?(RedmineTreeky::Patches::CustomFieldsHelperPatch)
  CustomFieldsHelper.send(:include, RedmineTreeky::Patches::CustomFieldsHelperPatch)
end



