class SpanishPodium
  include Mongoid::Document

  field :_id, type: Hash
  field :value, type: Hash

  def self.populate
    map = %Q{
      function() {
        var key = { person_id: this.person_id, person_name: this.person_name };
        var value = { gold: 0, silver: 0, bronze: 0 };
        var medal;
        if(this.pos == 1) medal = "gold";
        if(this.pos == 2) medal = "silver";
        if(this.pos == 3) medal = "bronze";
        value[medal] += 1;
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
    Result.spanish.podia.map_reduce(map, reduce).out(replace: collection_name).time
  end

  def self.print
    puts [
      "nombre".ljust(60, " "),
      "   oro",
      " plata",
      "bronce",
      " total"
    ].join("|")
    all.to_a.sort.each do |r|
      puts [
        r.person_name.ljust(60, " "),
        r.gold.to_s.rjust(6, " "),
        r.silver.to_s.rjust(6, " "),
        r.bronze.to_s.rjust(6, " "),
        r.total.to_s.rjust(6, " ")
      ].join("|")
    end
    nil
  end

  def <=>(other)
    sort_criteria <=> other.sort_criteria
  end

  def person_name
    _id["person_name"]
  end

  def gold
    value["gold"]
  end

  def silver
    value["silver"]
  end

  def bronze
    value["bronze"]
  end

  def total
    [ gold, silver, bronze ].sum
  end

  protected

  def sort_criteria
    [ -gold, -silver, -bronze, ActiveSupport::Inflector.transliterate(person_name) ]
  end
end
