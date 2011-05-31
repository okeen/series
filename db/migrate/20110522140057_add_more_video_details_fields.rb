class AddMoreVideoDetailsFields < ActiveRecord::Migration
  def self.up
    change_table :videos do |t|
      t.string :languaje, :default => 'en'
      t.string :subtitles
    end
  end

  def self.down
  end
end
