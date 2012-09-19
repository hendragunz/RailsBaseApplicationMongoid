class Profile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paperclip

  # fields
  field :bio, type: String
  field :birthdate, type: Date
  field :biography, type: String
  field :keywords, type: Array, default: []



  # relations
  belongs_to :business_type
  belongs_to :industry


  # attachment
  has_mongoid_attached_file :avatar,
    :path => ":rails_root/public/users/:attachment/:id/:style/:filename",
    :url => "/users/:attachment/:id/:style/:filename",
    :styles => {
      :original => ['256x256>', :png],
      :small    => ['32x32#',   :png],
      :medium   => ['64x64',    :png],
      :large    => ['128x128>', :png]
    },
    :default_url => User::NO_IMAGE

  # relations
  embedded_in :user

end