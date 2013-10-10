class Event
  include Mongoid::Document

  has_many :average_ranks
  has_many :single_ranks
  has_many :results

  field :_id, type: String
  field :name, type: String
  field :rank, type: Integer
  field :format, type: String
  field :cell_name, type: String
end
