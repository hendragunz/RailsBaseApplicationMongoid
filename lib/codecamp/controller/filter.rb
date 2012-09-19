module Codecamp
  module Controller
    module Filter
      extend ActiveSupport::Concern

      included do
        class_eval do
          @filters = {}
          class << self; attr_accessor :filters; end
        end
      end

      module ClassMethods
        def filter_with(name, options={}, &block)
          filter = {}.tap do |x|
            x[:param_name] = options.delete(:param_name) || name
          end
          filter[:block] = block
          self.filters[name] = filter
        end
      end

      def apply_filter(scope, *filters)
        _filters, _scope = self.class.filters, nil
        _filters = self.class.filters.slice(*filters) if filters.present?
        _filters.each do |name, filter|
          _scope = filter[:block].call(scope, value(filter[:param_name])) if params[filter[:param_name]]
        end
        _scope || scope
      end

      def value(name)
        params[name]
      end

    end

  end
end
