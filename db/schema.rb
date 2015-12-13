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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151213134914) do

  create_table "calendars", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "slug",        limit: 255
    t.text     "description", limit: 65535
    t.integer  "owner_id",    limit: 4
    t.boolean  "active"
    t.string   "timezone",    limit: 255
    t.string   "color",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "calendars", ["owner_id", "name"], name: "index_calendars_on_owner_id_and_name", unique: true, using: :btree
  add_index "calendars", ["owner_id", "slug"], name: "index_calendars_on_owner_id_and_slug", unique: true, using: :btree

  create_table "calendars_users", force: :cascade do |t|
    t.integer  "calendar_id", limit: 4
    t.integer  "user_id",     limit: 4
    t.string   "permissions", limit: 255, default: "R"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "calendars_users", ["calendar_id", "user_id"], name: "index_calendars_users_on_calendar_id_and_user_id", unique: true, using: :btree

  create_table "event_attachments", force: :cascade do |t|
    t.integer  "event_id",   limit: 4
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "event_attachments", ["event_id"], name: "index_event_attachs_on_event_id", using: :btree

  create_table "event_collections", force: :cascade do |t|
    t.integer  "eventable_id",   limit: 4
    t.string   "eventable_type", limit: 255
    t.integer  "user_id",        limit: 4
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "all_day",                    default: false
    t.string   "repetition",     limit: 255, default: "monthly"
    t.integer  "frequency",      limit: 4,   default: 1
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "event_collections", ["end_time"], name: "index_event_collections_on_end_time", using: :btree
  add_index "event_collections", ["eventable_id"], name: "index_event_collections_on_eventable_id", using: :btree
  add_index "event_collections", ["eventable_type"], name: "index_event_collections_on_eventable_type", using: :btree
  add_index "event_collections", ["start_time"], name: "index_event_collections_on_start_time", using: :btree
  add_index "event_collections", ["user_id"], name: "index_event_collections_on_user_id", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "uuid",                limit: 255
    t.integer  "eventable_id",        limit: 4
    t.string   "eventable_type",      limit: 255
    t.integer  "user_id",             limit: 4
    t.string   "title",               limit: 255
    t.text     "description",         limit: 65535
    t.string   "location",            limit: 255
    t.string   "color",               limit: 255
    t.string   "role",                limit: 255,   default: "event"
    t.datetime "start_time"
    t.datetime "end_time"
    t.boolean  "all_day",                           default: false
    t.integer  "event_collection_id", limit: 4
    t.string   "visibility",          limit: 255,   default: "PUBLIC"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "events", ["end_time"], name: "index_events_on_end_time", using: :btree
  add_index "events", ["event_collection_id"], name: "index_events_on_event_collection_id", using: :btree
  add_index "events", ["eventable_id"], name: "index_events_on_eventable_id", using: :btree
  add_index "events", ["eventable_type"], name: "index_events_on_eventable_type", using: :btree
  add_index "events", ["start_time"], name: "index_events_on_start_time", using: :btree
  add_index "events", ["user_id"], name: "index_events_on_user_id", using: :btree
  add_index "events", ["uuid"], name: "index_events_on_uuid", unique: true, using: :btree

  create_table "taggings", force: :cascade do |t|
    t.integer  "tag_id",        limit: 4
    t.integer  "taggable_id",   limit: 4
    t.string   "taggable_type", limit: 255
    t.integer  "tagger_id",     limit: 4
    t.string   "tagger_type",   limit: 255
    t.string   "context",       limit: 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true, using: :btree
  add_index "taggings", ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context", using: :btree

  create_table "tags", force: :cascade do |t|
    t.string  "name",           limit: 255
    t.integer "taggings_count", limit: 4,   default: 0
  end

  add_index "tags", ["name"], name: "index_tags_on_name", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",        null: false
    t.string   "encrypted_password",     limit: 255, default: "",        null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,         null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "language",               limit: 255
    t.string   "time_zone",              limit: 255
    t.string   "theme",                  limit: 255, default: "default"
    t.string   "authentication_token",   limit: 255
    t.boolean  "admin",                              default: false
    t.boolean  "enabled",                            default: true
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
