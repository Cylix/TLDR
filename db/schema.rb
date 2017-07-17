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

ActiveRecord::Schema.define(version: 20170717004026) do

  create_table "categories", force: :cascade do |t|
    t.string   "name",       default: "", null: false
    t.integer  "user_id",    default: 0,  null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "contents", force: :cascade do |t|
    t.string   "title",           default: "",                    null: false
    t.string   "url",             default: "",                    null: false
    t.text     "description",     default: "",                    null: false
    t.integer  "user_id",         default: 0,                     null: false
    t.integer  "source_id",       default: 0,                     null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.datetime "published_at"
    t.datetime "synchronized_at", default: '2017-04-18 07:07:49', null: false
    t.boolean  "is_pinned",       default: false,                 null: false
    t.integer  "status",          default: 0,                     null: false
    t.integer  "category_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string   "name",                  default: "", null: false
    t.string   "url",                   default: "", null: false
    t.string   "rss_feed",              default: "", null: false
    t.text     "description",           default: "", null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.integer  "user_id"
    t.string   "type",                  default: "", null: false
    t.datetime "last_synchronized_at"
    t.integer  "synchronization_state", default: 0,  null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name",             default: "", null: false
    t.string   "last_name",              default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
