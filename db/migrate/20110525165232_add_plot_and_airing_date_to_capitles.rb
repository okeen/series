class AddPlotAndAiringDateToCapitles < ActiveRecord::Migration
  def self.up
    change_table :capitles do |t|
      t.text :plot
      t.datetime :airing_date
      t.string :serie_title
    end
  end

  def self.down
  end
end
