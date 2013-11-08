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
      "pos",
      "nombre".ljust(35, " "),
      "   oro",
      " plata",
      "bronce",
      " total"
    ].join("|")
    i = 1
    all.to_a.sort.chunk do |r|
      [ r.gold, r.silver, r.bronze ]
    end.each do |_, rs|
      rs.each do |r|
        puts [
          i.to_s.rjust(3, " "),
          r.person_name.truncate(35).ljust(35, " "),
          r.gold.to_s.rjust(6, " "),
          r.silver.to_s.rjust(6, " "),
          r.bronze.to_s.rjust(6, " "),
          r.total.to_s.rjust(6, " ")
        ].join("|")
      end
      i += rs.size
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
    value["gold"].to_i
  end

  def silver
    value["silver"].to_i
  end

  def bronze
    value["bronze"].to_i
  end

  def total
    [ gold, silver, bronze ].sum
  end

  protected

  def sort_criteria
    [ -gold, -silver, -bronze, ActiveSupport::Inflector.transliterate(person_name) ]
  end
end
