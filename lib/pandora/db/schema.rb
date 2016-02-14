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

ActiveRecord::Schema.define(version: 20160214124820) do

  create_table "account_logs", force: :cascade do |t|
    t.integer  "account_id", limit: 4
    t.integer  "balance",    limit: 4
    t.string   "event",      limit: 255, default: "unknow",     null: false
    t.string   "channel",    limit: 255, default: "beautyshow", null: false
    t.integer  "from_user",  limit: 4
    t.integer  "to_user",    limit: 4
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
  end

  add_index "account_logs", ["account_id"], name: "index_account_logs_on_account_id", using: :btree
  add_index "account_logs", ["from_user"], name: "fk_rails_7eaf6f4a62", using: :btree
  add_index "account_logs", ["to_user"], name: "fk_rails_80c442fdae", using: :btree

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "balance",    limit: 4, default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "type",       limit: 255, default: "unknow", null: false
    t.string   "url",        limit: 255,                    null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",         limit: 255,                    null: false
    t.string   "gender",       limit: 255, default: "unknow"
    t.string   "phone_number", limit: 255
    t.integer  "avatar",       limit: 4
    t.integer  "vitality",     limit: 4,   default: 0
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "users", ["avatar"], name: "fk_rails_8dae096ac0", using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", using: :btree

  add_foreign_key "account_logs", "accounts"
  add_foreign_key "account_logs", "users", column: "from_user"
  add_foreign_key "account_logs", "users", column: "to_user"
  add_foreign_key "accounts", "users"
  add_foreign_key "users", "images", column: "avatar"
end
