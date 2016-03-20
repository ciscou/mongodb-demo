class NemesesCalculator
  def initialize(person, scope = :world)
    @person, @scope = person, scope
  end

  def nemeses
    nemesis_ids = category_nemeses(SingleRank) & category_nemeses(SingleRank)
    nemeses = Person.find(nemesis_ids)

    nemeses.select do |nemesis|
      case @scope
      when :world
        true
      when :continent
        nemesis.country.continent == @person.country.continent
      when :country
        nemesis.country_id == @person.country_id
      end
    end
  end

  private

  def category_nemeses(category)
    event_nemeses = category.where(person_id: @person.id).map do |rank|
      category.where(
        "event_id" => rank.event_id,
        "#{@scope}_rank" => {
          "$lt" => rank.send("#{@scope}_rank")
        }
      ).pluck(:person_id)
    end

    event_nemeses.inject do |a, e|
      a &= e
    end
  end
end
