class ContactInformation
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :city,      type: String
  field :zipcode,   type: String
  field :phone,     type: String
  field :street,    type: String
  field :fax,       type: String
  field :map_location, type: String
  field :country_ode, type: String


  # relations
  belongs_to :country
  embedded_in :user
end