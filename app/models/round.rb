class Round
  include Mongoid::Document

  has_many :results

  field :_id, type: String
  field :rank, type: Integer
  field :name, type: String
  field :cell_name, type: String
end
