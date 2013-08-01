require_dependency 'custom_fields_controller'

module RedmineEnhDragNDropCustomField
  module Patches
    module CustomFieldsControllerPatch
      def self.included(base) # :nodoc:
        base.extend(ClassMethods)
        base.send(:include, InstanceMethods)
        base.class_eval do
          alias_method_chain :update, :drag_n_drop
        end
      end

      module InstanceMethods
        def update_with_drag_n_drop
          if params[:insert_at] && @custom_field.insert_at(params[:insert_at])
            respond_to do |format|
              format.js { render nothing: true, status: :found }
            end
          else
            update
          end
        end
      end

      module ClassMethods

      end

    end
  end
end


unless CustomFieldsController.included_modules.include?(RedmineEnhDragNDropCustomField::Patches::CustomFieldsControllerPatch)
  CustomFieldsController.send(:include, RedmineEnhDragNDropCustomField::Patches::CustomFieldsControllerPatch)
end