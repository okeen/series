class AddMoreVideoDetailsFields < ActiveRecord::Migration
  def self.up
    alter_table :videos do |t|
      t.string :languaje, :default => 'en'
      t.string :subtitles
      t.string :description
    end
  end

  def self.down
  end
end
