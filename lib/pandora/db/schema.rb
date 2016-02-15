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

ActiveRecord::Schema.define(version: 20160215142345) do

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

  create_table "ad_images", force: :cascade do |t|
    t.string   "category",   limit: 255
    t.integer  "image_id",   limit: 4,   null: false
    t.string   "event",      limit: 255
    t.string   "args",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "ad_images", ["category"], name: "index_ad_images_on_category", using: :btree
  add_index "ad_images", ["image_id"], name: "fk_rails_3967fda917", using: :btree

  create_table "designers", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.integer  "shop_id",    limit: 4
    t.boolean  "is_vip",               default: false
    t.datetime "expired_at"
    t.integer  "stars",      limit: 4
    t.integer  "likes",      limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "designers", ["shop_id"], name: "index_designers_on_shop_id", using: :btree
  add_index "designers", ["user_id"], name: "index_designers_on_user_id", using: :btree

  create_table "favarite_designers", force: :cascade do |t|
    t.integer  "user_id",     limit: 4, null: false
    t.integer  "designer_id", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "favarite_designers", ["designer_id"], name: "index_favarite_designers_on_designer_id", using: :btree
  add_index "favarite_designers", ["user_id"], name: "index_favarite_designers_on_user_id", using: :btree

  create_table "favarite_images", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "image_id",   limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "favarite_images", ["image_id"], name: "index_favarite_images_on_image_id", using: :btree
  add_index "favarite_images", ["user_id"], name: "index_favarite_images_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "category",   limit: 255, default: "unknow", null: false
    t.string   "url",        limit: 255,                    null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "name",       limit: 255,   null: false
    t.string   "address",    limit: 255,   null: false
    t.string   "latitude",   limit: 255,   null: false
    t.string   "longtitude", limit: 255,   null: false
    t.string   "scale",      limit: 255
    t.string   "category",   limit: 255
    t.text     "desc",       limit: 65535
    t.integer  "created_by", limit: 4
    t.integer  "updated_by", limit: 4
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sms_codes", force: :cascade do |t|
    t.string   "phone_number", limit: 255
    t.string   "code",         limit: 255, null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "sms_codes", ["phone_number"], name: "index_sms_codes_on_phone_number", using: :btree

  create_table "twitter_images", force: :cascade do |t|
    t.integer  "twitter_id", limit: 4,             null: false
    t.integer  "image_id",   limit: 4,             null: false
    t.integer  "s_image_id", limit: 4,             null: false
    t.integer  "likes",      limit: 4, default: 0
    t.integer  "rank",       limit: 4,             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "twitter_images", ["image_id"], name: "fk_rails_dfbaf11298", using: :btree
  add_index "twitter_images", ["s_image_id"], name: "fk_rails_fa1b827e03", using: :btree
  add_index "twitter_images", ["twitter_id"], name: "index_twitter_images_on_twitter_id", using: :btree

  create_table "twitters", force: :cascade do |t|
    t.text     "content",     limit: 65535
    t.integer  "author",      limit: 4,                     null: false
    t.integer  "designer",    limit: 4,                     null: false
    t.string   "latitude",    limit: 255
    t.string   "longtitude",  limit: 255
    t.integer  "image_count", limit: 4
    t.boolean  "deleted",                   default: false
    t.integer  "stars",       limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "twitters", ["author"], name: "index_twitters_on_author", using: :btree
  add_index "twitters", ["designer"], name: "index_twitters_on_designer", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",         limit: 255,                    null: false
    t.string   "gender",       limit: 255, default: "unknow"
    t.string   "phone_number", limit: 255,                    null: false
    t.integer  "image_id",     limit: 4
    t.integer  "vitality",     limit: 4,   default: 0
    t.string   "status",       limit: 255, default: "nomal"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "users", ["image_id"], name: "fk_rails_47c7c64b36", using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", using: :btree

  create_table "vita_images", force: :cascade do |t|
    t.integer  "vita_id",    limit: 4
    t.integer  "image_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "vita_images", ["image_id"], name: "fk_rails_0f2b6df185", using: :btree
  add_index "vita_images", ["vita_id"], name: "index_vita_images_on_vita_id", using: :btree

  create_table "vitae", force: :cascade do |t|
    t.integer  "user_id",    limit: 4
    t.text     "desc",       limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "vitae", ["user_id"], name: "index_vitae_on_user_id", using: :btree

  add_foreign_key "account_logs", "accounts"
  add_foreign_key "account_logs", "users", column: "from_user"
  add_foreign_key "account_logs", "users", column: "to_user"
  add_foreign_key "accounts", "users"
  add_foreign_key "ad_images", "images"
  add_foreign_key "designers", "shops"
  add_foreign_key "designers", "users"
  add_foreign_key "favarite_designers", "users"
  add_foreign_key "favarite_designers", "users", column: "designer_id"
  add_foreign_key "favarite_images", "images"
  add_foreign_key "favarite_images", "users"
  add_foreign_key "twitter_images", "images"
  add_foreign_key "twitter_images", "images", column: "s_image_id"
  add_foreign_key "twitters", "users", column: "author"
  add_foreign_key "twitters", "users", column: "designer"
  add_foreign_key "users", "images"
  add_foreign_key "vita_images", "images"
  add_foreign_key "vita_images", "vitae", column: "vita_id"
  add_foreign_key "vitae", "users"
end
