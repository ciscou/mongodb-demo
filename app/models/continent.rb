class Continent
  include Mongoid::Document

  has_many :countries

  field :_id, type: String
  field :name, type: String
  field :record_name, type: String
  field :latitude, type: Integer
  field :longitude, type: Integer
  field :zoom, type: Integer
end
