require_dependency 'issues_controller'

module RedmineTag
  module Patches
    module IssuesControllerPatch
      def self.included(base)
        # base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :retrieve_previous_and_next_issue_ids, :tags
        end
      end

      module InstanceMethods
        def retrieve_previous_and_next_issue_ids_with_tags
          retrieve_query_from_session
          if @query
            sort_init(@query.sort_criteria.empty? ? [['id', 'desc']] : @query.sort_criteria)
            sort_update(@query.sortable_columns, 'issues_index_sort')
            limit = 500
            # Include the tags and tag_descriptor in the query
            issue_ids = @query.issue_ids(:order => sort_clause, :limit => (limit + 1), :include => [:assigned_to, :tracker, :priority, :category, :fixed_version, tags: [:tag_descriptor]]).uniq
            if (idx = issue_ids.index(@issue.id)) && idx < limit
              if issue_ids.size < 500
                @issue_position = idx + 1
                @issue_count = issue_ids.size
              end
              @prev_issue_id = issue_ids[idx - 1] if idx > 0
              @next_issue_id = issue_ids[idx + 1] if idx < (issue_ids.size - 1)
            end
          end
        end
      end

      module ClassMethods
      end

    end
  end
end

unless IssuesController.included_modules.include?(RedmineTag::Patches::IssuesControllerPatch)
  IssuesController.send(:include, RedmineTag::Patches::IssuesControllerPatch)
end
