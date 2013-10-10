class Format
  include Mongoid::Document

  has_many :results

  field :_id, type: String
  field :name, type: String
end
