module Codecamp
  module Supports
    extend ActiveSupport::Concern

    included do
      include Codecamp::Supports::Response
      before_filter :routine_data
      layout :determine_layout
      protect_from_forgery
    end

    protected

    # set skeleton presistent data
    def routine_data
      return if controller_path.match(/\//)
      @categories = Category.publics
      @page = params[:page]||1
      @limit = params[:limit]||25
    end

    # chose selected layout base on request type
    def determine_layout
      request.xhr? ? 'ajax' : common_layout
    end

    def common_layout
      return 'devise' if devise_controller?
      Rails.logger.debug self.class.to_s.split("::").first
      (self.class.to_s.split("::").first =~ /Admin|Member/i) ? 'solar' : 'application'
    end

    def after_sign_in_path_for(resource)
      # return request.env['omniauth.origin'] || stored_location_for(resource) || (resource.is_a?(Admin) ? admin_dashboard_path : member_root_path)
      last_request = session[:return_to]
      session[:return_to] = nil
      return last_request || stored_location_for(resource) || (resource.is_a?(Admin) ? admin_dashboard_path : member_root_path)
    end

  end
end
