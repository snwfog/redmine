require 'acts_as_customizable'

module RedmineTreeky
  module Patches
    module ActsAsCustomizablePatch
      def self.included(base)
        base.send :include, InstanceMethods
      end

      module InstanceMethods
        def custom_field_values_with_args(args)
          @custom_field_values = args.collect do |field|
            x = CustomFieldValue.new
            x.custom_field = field
            x.customized = self
            if field.multiple?
              values = custom_values.select { |v| v.custom_field == field }
              if values.empty?
                values << custom_values.build(:customized => self, :custom_field => field, :value => nil)
              end
              x.value = values.map(&:value)
            else
              cv = custom_values.detect { |v| v.custom_field == field }
              cv ||= custom_values.build(:customized => self, :custom_field => field, :value => nil)
              x.value = cv.value
            end
            x
          end
        end
      end
    end
  end
end

ActiveRecord::Base.send(:include, RedmineTreeky::Patches::ActsAsCustomizablePatch)