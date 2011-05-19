class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :title
      t.text :description
      t.integer :seasons_count
      t.integer :capitles_count

      t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end
