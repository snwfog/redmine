require 'query'

module RedmineTag
  module Patches
    module QueryPatch
      def self.included(base)
        base.send(:include, InstanceMethods)
        base.extend(ClassMethods)

        base.class_eval do
          alias_method_chain :statement, :tags
        end
      end

      module InstanceMethods
        def statement_with_tags
          sql_statement = statement_without_tags
          if sql_statement.split('AND').count >= 2
            sql_statement = sql_statement.split('AND').join(') AND (')
          end
          sql_statement
        end

        def sql_for_tag_descriptors_description_field(field, operator, value)
          db_table = TagDescriptor.table_name
          db_field = 'id' # tag_descriptor.id
          filter = @available_filters[field]
          sql = sql_for_field(field, operator, value, db_table, db_field, true)
          #reject_empty_string_clause(sql)
        end

        private
        def reject_empty_string_clause(sql)
          stmt = sql.split(' AND ').reject{|stmt| stmt =~ /<> ''/}.join(' AND ')
          if stmt =~ /(NOT NULL)|(IN)/
            stmt
          elsif stmt =~ /IS NULL/
            "(" + stmt + ")"
          elsif stmt =~ /CAST/ || !stmt.blank?
            "(" + stmt
          else
            ""
          end
        end
      end


      module ClassMethods

      end

    end
  end
end

Query.send(:include, RedmineTag::Patches::QueryPatch)