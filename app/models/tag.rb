class Tag
  # includes
  include Mongoid::Document
  include Mongoid::Timestamps

  # constants

  # attributes accessors, readers, writers
  attr_accessible :name

  # features

  # fields
  field :name,   type: String
  field :total,  type: Integer,  default: 0

  index({name: 1})


  # validations
  validates :name, :presence => true, :uniqueness => true

  # callbacks
  before_save     :downcase_name

  # scopes
  scope :popular, desc('total')


  # private methods
  private

  def downcase_name
    self.name = name.downcase.strip if name.present?
  end

end