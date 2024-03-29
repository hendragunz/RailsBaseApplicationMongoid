module Codecamp::Errors

  class BaseError < StandardError
    attr_reader :action, :subject
    attr_writer :default_message

    def initialize(message = nil, action = nil, subject = nil)
      @message = message
      @action = action
      @subject = subject
      @default_message = I18n.t(:"unauthorized.default", :default => "Maaf untuk sementara waktu halaman ini tidak bisa diakses.")
    end

    def to_s
      @message || @default_message
    end
  end

  class PageNotFound < BaseError;end
  class Maintenance < BaseError;end

end