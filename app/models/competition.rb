class Competition
  include Mongoid::Document

  belongs_to :country

  has_many :results

  field :_id, type: String
  field :name, type: String
  field :city_name, type: String
  field :information, type: String
  field :year, type: Integer
  field :month, type: Integer
  field :day, type: Integer
  field :end_month, type: Integer
  field :end_day, type: Integer
  field :event_specs, type: String
  field :wca_delegate, type: String
  field :organiser, type: String
  field :venue, type: String
  field :venue_address, type: String
  field :venue_details, type: String
  field :website, type: String
  field :cell_name, type: String
  field :latitude, type: Integer
  field :longitude, type: Integer
end
