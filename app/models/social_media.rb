class SocialMedia
  include Mongoid::Document
  include Mongoid::Timestamps

  # fields
  field :facebook, type: String
  field :facebook_page, type: String
  field :twitter,  type: String
  field :google,   type: String
  field :linkedin, type: String
  field :youtube,  type: String
  field :blog_rss, type: String

  # relations
  embedded_in :user


end