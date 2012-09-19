module Codecamp
  module Supports
    module Bases

      private

      def index_url
        controller_path.gsub(/\//,'_') + "_url"
      end

      def model_param
        model.to_sym
      end

      def model_var_str
        "@#{model}"
      end

      def model
        controller_name.gsub(/admin_/i,'').singularize
      end

      def model_args
        params[model_param]
      end

      def model_var
        eval(model_var_str)
      end

      def model_vars
        eval("@#{model.pluralize}")
      end

      def ids_symb
        "#{model}_ids".to_sym
      end

      def model_klass
        model.split(/_/).map(&:camelize).join('').constantize
      end

      def delete_request?
        params[:delete].present? || params[:destroy].present?
      end

      def variable_set(criteria, opts={})
        instance_variable_set(model_var_str, model_klass.send(criteria, opts))
      end

    end
  end
end