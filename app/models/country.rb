class Country
  include Mongoid::Document

  belongs_to :continent

  has_many :results, foreign_key: :person_country_id
  has_many :competitions
  has_many :people

  field :_id, type: String
  field :name, type: String
  field :latitude, type: Integer
  field :longitude, type: Integer
  field :zoom, type: Integer
  field :iso2, type: String
end
