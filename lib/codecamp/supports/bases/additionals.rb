# Module Name : Object
# Description : Additional methods to produce request in base controller. Please see method description below.
module Codecamp
  module Supports
    module Bases

      module Additionals

        # Telling model to delete spesific objects.
        # Recommendation: Ajax Request
        def delete_multiple
          model_klass.find(params[ids_symb]).map(&:delete)
          should_respond(:with_head, :ok) do
            if request.xhr?
              render text: "Ok"
            else
              redirect_to request.env["HTTP_REFERER"], notice: "Penghapusan data telah berhasil dilakukan"
            end
          end
        end

        # Telling model to sort spesific objects
        def save_sorts
          if params[:sorts].present?
            Codecamp::Utils.sort_by(params, :sorts, model_klass)
            notification = "#{model} data telah berhasil diurutkan."
          end
          should_respond(:with_head, :ok){redirect_to request.env["HTTP_REFERER"], notice: notification}
        end
      end

    end
  end
end