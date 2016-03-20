class NemesesController < ApplicationController
  def index
    @wcaid, @scope = params.values_at(:wcaid, :scope)

    if @wcaid.present? && %w[world continent country].include?(@scope)
      @wcaid = @wcaid.upcase

      begin
        @person  = Person.find(@wcaid)
        @nemeses = NemesesCalculator.new(@person, @scope.to_sym).nemeses
      rescue Mongoid::Errors::DocumentNotFound
        # never mind :)
      end
    end
  end
end
