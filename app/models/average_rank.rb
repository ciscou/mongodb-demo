class AverageRank
  include Mongoid::Document

  belongs_to :person
  belongs_to :event

  field :best, type: Integer
  field :world_rank, type: Integer
  field :continent_rank, type: Integer
  field :country_rank, type: Integer

  index person_id: 1

  index event_id: 1, world_rank: 1
  index event_id: 1, continent_rank: 1
  index event_id: 1, country_rank: 1
end
