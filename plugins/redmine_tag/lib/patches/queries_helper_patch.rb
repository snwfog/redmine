require 'queries_helper'

module RedmineTag
  module Patches
    module QueriesHelperPatch
      def self.included(base)
        base.extend(ClassMethods)

        base.class_eval do
          class << self

          end
        end
      end

      module ClassMethods

      end
    end
  end
end

QueriesHelper.send(:include, RedmineTag::Patches::QueriesHelperPatch)