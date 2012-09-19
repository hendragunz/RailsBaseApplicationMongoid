module Codecamp
  module Controller
    module Sorter
      extend ActiveSupport::Concern

      included do
        class_eval do
          @sorts = {}
          class << self; attr_accessor :sorts; end
        end
      end

      module ClassMethods
        def sort_with(name, options={}, &block)
          filter = {}.tap do |x|
            x[:param_name] = options.delete(:param_name) || name
          end
          filter[:block] = block
          self.sorts[name] = filter
        end
      end

      def apply_sort(scope, default=nil)
        sort_name = params[:sort] || default || (return scope)
        sort_name = default unless self.class.sorts.keys.include?(sort_name.to_sym)
        self.class.sorts[sort_name.to_sym][:block].call(scope)
      end
    end

  end
end
