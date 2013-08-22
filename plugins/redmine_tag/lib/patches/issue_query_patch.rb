require_dependency 'issue_query'

module RedmineTag
  module Patches
    module IssueQueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)

        cols =
        [
          QueryTagDescriptionColumn.new(
            :tag_description,
            sortable: "#{TagDescriptor.table_name}.description",
            groupable: false
          )
        ]

        base.available_columns |= cols
        base.class_eval do
          alias_method_chain :initialize_available_filters, :tags
        end
      end

      module InstanceMethods
        def initialize_available_filters_with_tags
          initialize_available_filters_without_tags

          tag_descriptor = TagDescriptor.all.map
          add_available_filter("tag_descriptors_description", type: :list_optional,
            values: TagDescriptor.order('description ASC').all.map {|td| [td.description, td.id.to_s]})
        end
      end

      module ClassMethods

      end


    end
  end
end

IssueQuery.send(:include, RedmineTag::Patches::IssueQueryPatch)