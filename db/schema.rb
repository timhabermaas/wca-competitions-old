# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20111221020324) do

  create_table "competitions", :force => true do |t|
    t.string   "name",                          :null => false
    t.date     "starts_at",                     :null => false
    t.date     "ends_at",                       :null => false
    t.integer  "user_id",                       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "closed",     :default => false, :null => false
    t.text     "details"
  end

  create_table "competitors", :force => true do |t|
    t.string   "first_name",    :null => false
    t.string   "last_name"
    t.string   "wca_id"
    t.date     "date_of_birth", :null => false
    t.string   "gender",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "wca"
  end

  create_table "news", :force => true do |t|
    t.text     "content",        :null => false
    t.integer  "competition_id", :null => false
    t.integer  "user_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news_translations", :force => true do |t|
    t.integer  "news_id"
    t.string   "locale"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news_translations", ["news_id"], :name => "index_news_translations_on_news_id"

  create_table "registrations", :force => true do |t|
    t.integer  "competition_id", :null => false
    t.integer  "competitor_id",  :null => false
    t.string   "email",          :null => false
    t.string   "days_as_guest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations_schedules", :force => true do |t|
    t.integer  "schedule_id",     :null => false
    t.integer  "registration_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedules", :force => true do |t|
    t.integer  "event_id",                          :null => false
    t.integer  "competition_id",                    :null => false
    t.time     "starts_at"
    t.time     "ends_at"
    t.integer  "day",                               :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "registerable",   :default => false, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name",                                     :null => false
    t.string   "email",                                    :null => false
    t.string   "password_digest",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role",            :default => "organizer", :null => false
  end

end
