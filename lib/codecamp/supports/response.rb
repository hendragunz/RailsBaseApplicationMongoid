# Module Name: Response
# Descrtion  : A respond To Handler
module Codecamp
  module Supports
    module Response
      extend ActiveSupport::Concern

      MIME_REFERENCES = Mime::HTML.respond_to?(:ref)

      included do
        respond_to :html, :xml, :json, :pdf , :js
        with_options(with: :page_not_found) do |page_error|
          page_error.rescue_from Codecamp::Errors::PageNotFound
          page_error.rescue_from ActionController::RoutingError
        end
      end

      private

        def page_not_found
          render_name = determine_layout
          render_name = render_name.is_a?(String) ? render_name : 'solar'
          should_respond(error_object('page not found')){render send("#{render_name}_not_found_path")}
        end

        def error_object(message = ERR_ACCESS)
          {error: message}
        end

        def should_respond(*args, &block)
          if args.first.is_a?(Symbol)
            key = args.shift
            send("should_respond_#{key.to_s}", args, &block)
          else
            respond_with(*args) do |format|
              format.any(*navigational_formats, &block)
            end
          end
        end

        def should_respond_with_head(args, &block)
          respond_to do |format|
            format.html(&block)
            format.json { head sym }
            format.xml  { head sym }
          end
        end

        def request_format
          @request_format ||= if request.format.respond_to?(:ref)
            request.format.ref
          elsif MIME_REFERENCES
            request.format
          elsif request.format # Rails < 3.0.4
            request.format.to_sym
          end
        end

        def navigational_formats
          @navigational_formats ||= Devise.navigational_formats.select{ |format| Mime::EXTENSION_LOOKUP[format.to_s] }
        end

        def is_navigational_format?
          Devise.navigational_formats.include?(request_format)
        end

        def set_flash_message(key, kind, options={}) #:nodoc:
          return nil unless is_navigational_format?
          message = I18n.t("#{controller_name}.#{kind}")
          flash[key] = message if message.present?
        end

        def should_respond_after_save(args, &block)
          is_true, object, options = args.shift, args.shift, args.shift||{}
          if is_true
            set_flash_message :notice, params[:action].to_sym
            callback_to = url_after_save(:success, options[:success_to].to_s)
          else
            callback_to = url_after_save(:failed, options[:failed_to].to_s)
            object = {errors: object.errors.messages}
          end

          should_respond(object) do
            if callback_to.to_s =~ /\//i
              redirect_to callback_to
            else
              render callback_to
            end
          end
        end

        def url_after_save(is_success, str = "")
          if is_success == :success
            return str.blank? ? send("#{controller_path.gsub(/\//,'_')}_url") : str
          else
            return params[:action] =~ /create/i ? :new : :edit
          end
        end
    end
  end
end