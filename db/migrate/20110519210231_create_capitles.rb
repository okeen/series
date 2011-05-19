class CreateCapitles < ActiveRecord::Migration
  def self.up
    create_table :capitles do |t|
      t.string :title
      t.references :serie
      t.integer :season , :default => 0
      t.integer :order, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :capitles
  end
end
