require "yaml"
require "ostruct"
# Module Name : Object
# Description : a stand alone module to produce object. Please see method description below.
module Codecamp
  module Utils
    module Object

      def self.shorten_url(url)
        bitly = Bitly.new(Settings.bitly_user, Settings.bitly_api)
        bitly.shorten(url).short_url
      rescue
        url
      end

      def self.sort_by(params, key, klass)
        orders = params[key].gsub(/\,$/,"").split(",")
        counter = 1
        orders.each do |kc_id|
          item = klass.find(kc_id)
          if item
            item.update_attributes({:position => counter})
            counter += 1
          end
        end
      end

    end
  end
end
