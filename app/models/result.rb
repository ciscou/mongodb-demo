class Result
  include Mongoid::Document

  scope :spanish, lambda { where(person_country_id: "Spain") }
  scope :podia, lambda { where(round_id: { "$in" => %w[c f] }, pos: { "$lte" => 3 }, best: { "$gt" => 0 }) }

  belongs_to :competition
  belongs_to :event
  belongs_to :round
  belongs_to :person
  belongs_to :person_country, class_name: "Country"
  belongs_to :format

  field :pos, type: Integer
  field :best, type: Integer
  field :average, type: Integer
  field :person_name, type: String
  field :value1, type: Integer
  field :value2, type: Integer
  field :value3, type: Integer
  field :value4, type: Integer
  field :value5, type: Integer
  field :regional_single_record, type: String
  field :regional_average_record, type: String
end
