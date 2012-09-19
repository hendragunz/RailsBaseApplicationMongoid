class Settings < Settingslogic
  source "#{Rails.root}/config/baseapp_setting.yml"
  namespace Rails.env
end