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

ActiveRecord::Schema.define(:version => 20110531140535) do

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

  create_table "user_sessions", :force => true do |t|
    t.string   "access_token"
    t.integer  "expires"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                          :null => false
    t.string   "name",                              :null => false
    t.string   "last_name"
    t.string   "middle_name"
    t.string   "email",                             :null => false
    t.string   "location"
    t.string   "gender"
    t.integer  "timezone"
    t.string   "locale"
    t.string   "persistence_token"
    t.string   "access_token"
    t.string   "facebook_id"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.string   "password"
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
