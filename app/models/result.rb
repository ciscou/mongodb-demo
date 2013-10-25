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

  def self.spanish_medal_table
    map = %Q{
      function() {
        var key = { person_id: this.person_id, person_name: this.person_name };
        var value = { gold: 0, silver: 0, bronze: 0 };
        var medal;
        if(this.pos == 1) medal = "gold";
        if(this.pos == 2) medal = "silver";
        if(this.pos == 3) medal = "bronze";
        value[medal] = 1;
        emit(key, value);
      }
    }
    reduce = %Q{
      function(key, values) {
        var result = { gold: 0, silver: 0, bronze: 0 };
        values.forEach(function(value) {
          result.gold   += value.gold;
          result.silver += value.silver;
          result.bronze += value.bronze;
        });
        return result;
      }
    }
    print_medal_table spanish.podia.map_reduce(map, reduce).out(inline: true).to_a
  end

  private

  def self.print_medal_table(result)
    result.sort_by! do |r|
      v = r["value"]
      [ -v["gold"], -v["silver"], -v["bronze"], ActiveSupport::Inflector.transliterate(r["_id"]["person_name"]) ]
    end
    puts [
      "nombre".ljust(40, " "),
      "oro   ",
      "plata ",
      "bronce",
      "total "
    ].join("|")
    result.each do |r|
      gold, silver, bronze = %w[gold silver bronze].map { |m| r["value"][m].to_i }
      puts [
        r["_id"]["person_name"].ljust(40, " "),
        gold.to_s.rjust(6, " "),
        silver.to_s.rjust(6, " "),
        bronze.to_s.rjust(6, " "),
        [gold, silver, bronze].sum.to_s.rjust(6, " ")
      ].join("|")
    end
    nil
  end
end
