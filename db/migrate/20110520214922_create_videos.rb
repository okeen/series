class CreateVideos < ActiveRecord::Migration
  def self.up
    create_table :videos do |t|
      t.references :capitle
      t.string :url
      t.string :visualization_type
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :videos
  end
end
