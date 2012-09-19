module Codecamp
  module Helpers
    module TimeUnits
      Waktu = 0
      Detik = 1
      Menit = Detik * 60
      Jam = Menit * 60
      Hari = Jam * 24
      Minggu = Hari * 7
      Bulan = Minggu * 4
      Tahun = Hari * 365
      Dekade = Tahun * 10
      Abad = Dekade * 10
      Milenium = Abad * 10
      Eon = 1.0/0
    end

    extend ActionView::Helpers::TagHelper

    def self.resource_error_messages!(res = nil, res_name = nil)
      return "" if res.blank?
      res_name ||= defined?(resource_name) ? resource_name : res.class
      return "" if res.errors.empty?

      uniq_errors = res.errors.full_messages.uniq
      messages = uniq_errors.map { |msg| content_tag(:li, msg) }.join

      html = <<-HTML
        <div class="alert alert-block alert-error fade in">
          <b>Telah terjadi #{uniq_errors.count} kesalahan dari proses sebelumnya:</b>
          <ul>#{messages}</ul>
        </div>
        HTML
      html.html_safe
    end

    def self.time_ago(time)
      time_difference = Time.now.to_i - time.to_i
      Rails.logger.debug time_difference
      unit = self.get_unit(time_difference)
      devider = Codecamp::Helpers::TimeUnits.const_get(unit)
      unit_difference = devider > 0 ? (time_difference / devider) : "beberapa"

      unit = unit.to_s.downcase

      "#{unit_difference} #{unit} lalu"
    end

    private
    def self.get_unit(time_difference)
      Codecamp::Helpers::TimeUnits.constants.each_cons(2) do |con|
        return con.first if (Codecamp::Helpers::TimeUnits.const_get(con[0])...Codecamp::Helpers::TimeUnits.const_get(con[1])) === time_difference
      end
    end

  end
end