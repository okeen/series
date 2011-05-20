class Capitle < ActiveRecord::Base
  belongs_to :serie

  has_many :videos
  
  before_create :update_serie_season_count_if_needed, :increment_serie_capitles_count

  #parameterized named scopes
  class<<self
    def for_season(season_num)
      where(:season => season_num)
    end

    def season_capitle(season,capitle)
      for_season(season).where(:order => capitle).first
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
