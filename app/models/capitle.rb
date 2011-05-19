class Capitle < ActiveRecord::Base
  belongs_to :serie

  before_create :update_serie_season_count_if_needed, :increment_serie_capitles_count

  #parameterized named scopes
  class<<self
    def for_season(season_num)
      where(:season => season_num)
    end
  end

  private
  def update_serie_season_count_if_needed
    serie.update_attribute(:seasons_count, season) unless serie.seasons_count >= season
  end

  def increment_serie_capitles_count
    serie.increment! :capitles_count
  end
end
