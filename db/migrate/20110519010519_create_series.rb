class CreateSeries < ActiveRecord::Migration
  def self.up
    create_table :series do |t|
      t.string :title
      t.text :description
      t.integer :seasons_count, :default => 0
      t.integer :capitles_count, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :series
  end
end
