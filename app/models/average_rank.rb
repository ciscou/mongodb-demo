class AverageRank
  include Mongoid::Document

  belongs_to :person
  belongs_to :event

  field :best, type: Integer
  field :world_rank, type: Integer
  field :continent_rank, type: Integer
  field :country_rank, type: Integer
end
