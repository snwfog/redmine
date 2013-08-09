require_dependency 'issue_query'

module RedmineTag
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)

        base.available_columns << QueryColumn.new(:tag_severity,
          sortable: "#{Tag.table_name}.severity", groupable: true)
        base.available_columns << QueryColumn.new(:tag_description,
          sortable: "#{TagDescriptor.table_name}.description", groupable: true)

        base.class_eval do
          alias_method_chain :initialize_available_filters, :tags
        end
      end

      module InstanceMethods
        def initialize_available_filters_with_tags
          initialize_available_filters_without_tags

          add_available_filter("tag_severity", type: :integer)
          add_available_filter("tag_descriptor_id", type: :list_optional,
            values: TagDescriptor.all.map {|td| [td.description, td.id.to_s]})
        end

      end

      module ClassMethods

      end


    end
  end
end

IssueQuery.send(:include, RedmineTag::Patches::IssueQueryPatch)