class Person
  include Mongoid::Document

  belongs_to :country

  has_many :average_ranks
  has_many :single_ranks
  has_many :results

  field :_id, type: String
# field :subid, type: Integer
  field :name, type: String
  field :gender, type: String
end
