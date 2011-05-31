# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110525165232) do

  create_table "capitles", :force => true do |t|
    t.string   "title"
    t.integer  "serie_id"
    t.integer  "season",      :default => 0
    t.integer  "order",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "plot"
    t.datetime "airing_date"
    t.string   "serie_title"
  end

  create_table "series", :force => true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "seasons_count",  :default => 0
    t.integer  "capitles_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "videos", :force => true do |t|
    t.integer  "capitle_id"
    t.string   "url"
    t.string   "visualization_type"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "languaje",           :default => "en"
    t.string   "subtitles"
  end

end
