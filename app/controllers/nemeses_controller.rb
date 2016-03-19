class NemesesController < ApplicationController
  def index
    @wcaid, @scope = params.values_at(:wcaid, :scope)
    if @wcaid.present? && %w[world continent country].include?(@scope)
      @nemeses = NemesesCalculator.new(@wcaid, @scope.to_sym).nemeses
    end
  end
end
