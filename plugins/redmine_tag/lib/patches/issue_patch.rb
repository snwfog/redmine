require_dependency 'issue'

module RedmineTag
  module Patches
    module IssuePatch
      def self.included(base)
        # base.extend(ClassMethods)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          #default_scope { joins('LEFT OUTER JOIN tags ON tags.issue_id = issues.id')
          #  .joins('LEFT OUTER JOIN tag_descriptors ON tags.tag_descriptor_id = tag_descriptors.id') }
          default_scope { includes(tags: [:tag_descriptor]) }

          has_many :tags, dependent: :destroy
          has_many :tag_descriptors, through: :tags

          safe_attributes 'tags',
          :if => lambda { |issue, user| issue.new_record? || user.allowed_to?(:edit_issues, issue.project)  }



          alias_method_chain :init_journal, :tags
          alias_method_chain :create_journal, :tags
          alias_method_chain :assign_attributes, :tags_removed
        end
      end

      module InstanceMethods
        def build_tag_from_param(tags_hash)
          @params_tags = tags_hash || []
          return @params_tags if @params_tags.empty?

          Tag.transaction do
            self.tags.destroy_all
            tags = @params_tags.split(',').reject(&:blank?).map do |tag|
              description = tag.scan(/[\w\s]+/).pop.strip
              tag_descriptor = TagDescriptor.find_by_description(description)
              tag_descriptor ||= TagDescriptor.create(description: description)
              params =
              {
                tag_descriptor_id: tag_descriptor.id,
                issue_id: self.id
              }

              tag = Tag.unscoped.where(params).first_or_initialize
            end
          end
        end

        def assign_attributes_with_tags_removed(new_attributes, *args)
          unless new_attributes[:tags].nil?
            tags = build_tag_from_param(new_attributes.delete(:tags))
            self.tags << tags unless (tags.nil? || tags.empty?)
          end

          assign_attributes_without_tags_removed(new_attributes, *args)
        end

        def init_journal_with_tags(user, notes="")
          init_journal_without_tags(user, notes)
          if new_record?
            # No yet handled
          else
            @tags_before_change = self.tags.dup
          end
        end

        def create_journal_with_tags
          if @current_journal
            if @tags_before_change
              @tags_before_change.each do |tag|
                unless (self.tag_descriptor_ids.include?(tag.tag_descriptor_id))
                  # Then this tag is removed
                  @current_journal.details << JournalDetail.new(property: "tag", prop_key: 0, old_value: tag.tag_descriptor.description, value: nil)
                end
              end

              # Added tags
              self.reload
              old_tag_descriptor_ids = @tags_before_change.map(&:tag_descriptor_id)
              self.tags.each do |tag|
                unless old_tag_descriptor_ids.include?(tag.tag_descriptor_id)
                  @current_journal.details << JournalDetail.new(property: "tag", prop_key: 0, old_value: nil, value: tag.tag_descriptor.description)
                end
              end

            end
          end
          create_journal_without_tags
        end
      end

      module ClassMethods
      end

    end
  end
end

unless Issue.included_modules.include?(RedmineTag::Patches::IssuePatch)
  Issue.send(:include, RedmineTag::Patches::IssuePatch)
end
