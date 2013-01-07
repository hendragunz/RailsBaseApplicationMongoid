class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Codecamp::Ext::UserAuthentication

  field :firstname,                 :type => String
  field :lastname,                  :type => String
  field :bio,                       :type => String
  field :website,                   :type => String
  field :location,                  :type => String
  field :birthday,                  :type => Time

  field :identity_url,              :type => String
  field :preferred_languages,       :type => Set, :default => []

  field :language,                  :type => String, :default => "en"
  field :timezone,                  :type => String
  field :country_code,              :type => String
  field :country_name,              :type => String, :default => "unknown"

  # indexing
  index({identity_url: 1})

  # relations
  embeds_one :profile, cascade_callbacks: true
  embeds_one :contact_information, cascade_callbacks: true
  embeds_one :social_media, cascade_callbacks: true

  validates_length_of       :firstname,     :maximum => 100
  validates_length_of       :lastname,     :maximum => 100

  # accepts nested attributes
  accepts_nested_attributes_for :profile

  # return fullname if present, otherwise login name
  def display_name
    fullname? ? fullname : username
  end

  # return true if firstname or lastname present
  def fullname?
    firstname.present? || lastname.present?
  end

  # return firstname and lastname
  def fullname
    "#{firstname} #{lastname}"
  end

end
