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

ActiveRecord::Schema.define(version: 20160313211111) do

  create_table "account_logs", force: :cascade do |t|
    t.integer  "account_id", limit: 4
    t.integer  "balance",    limit: 4
    t.string   "event",      limit: 255, default: "unknow",     null: false
    t.string   "channel",    limit: 255, default: "beautyshow", null: false
    t.integer  "from_user",  limit: 4
    t.integer  "to_user",    limit: 4
    t.string   "desc",       limit: 255
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

  create_table "commissioners", force: :cascade do |t|
    t.string   "phone_number",     limit: 255,                    null: false
    t.string   "name",             limit: 255
    t.string   "password",         limit: 10,  default: "888888"
    t.integer  "code_image_id",    limit: 4
    t.string   "status",           limit: 255, default: "normal"
    t.integer  "be_scanned_times", limit: 4,   default: 0
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "commissioners", ["code_image_id"], name: "fk_rails_fa70faddc9", using: :btree
  add_index "commissioners", ["phone_number"], name: "index_commissioners_on_phone_number", using: :btree

  create_table "designer_called_logs", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.integer  "designer_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "designer_called_logs", ["designer_id"], name: "index_designer_called_logs_on_designer_id", using: :btree
  add_index "designer_called_logs", ["user_id"], name: "index_designer_called_logs_on_user_id", using: :btree

  create_table "designers", force: :cascade do |t|
    t.integer  "user_id",       limit: 4,                 null: false
    t.integer  "shop_id",       limit: 4
    t.boolean  "is_vip",                  default: false
    t.datetime "expired_at"
    t.integer  "totally_stars", limit: 4, default: 0
    t.integer  "monthly_stars", limit: 4, default: 0
    t.integer  "weekly_stars",  limit: 4, default: 0
    t.integer  "likes",         limit: 4, default: 0
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "designers", ["shop_id"], name: "index_designers_on_shop_id", using: :btree
  add_index "designers", ["user_id"], name: "index_designers_on_user_id", using: :btree

  create_table "favorite_designers", force: :cascade do |t|
    t.integer  "user_id",     limit: 4, null: false
    t.integer  "designer_id", limit: 4, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "favorite_designers", ["designer_id"], name: "index_favorite_designers_on_designer_id", using: :btree
  add_index "favorite_designers", ["user_id"], name: "index_favorite_designers_on_user_id", using: :btree

  create_table "favorite_images", force: :cascade do |t|
    t.integer  "user_id",    limit: 4, null: false
    t.integer  "image_id",   limit: 4, null: false
    t.integer  "twitter_id", limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "favorite_images", ["image_id"], name: "index_favorite_images_on_image_id", using: :btree
  add_index "favorite_images", ["twitter_id"], name: "fk_rails_abb4192bb2", using: :btree
  add_index "favorite_images", ["user_id"], name: "index_favorite_images_on_user_id", using: :btree

  create_table "images", force: :cascade do |t|
    t.string   "category",          limit: 255, default: "unknow", null: false
    t.string   "url",               limit: 255,                    null: false
    t.integer  "original_image_id", limit: 4
    t.integer  "likes",             limit: 4
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "images", ["original_image_id"], name: "fk_rails_5e5acaf60a", using: :btree

  create_table "login_users", primary_key: "user_id", force: :cascade do |t|
    t.string   "access_token", limit: 255
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "login_users", ["user_id"], name: "index_login_users_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "user_id",    limit: 4,                    null: false
    t.text     "content",    limit: 65535
    t.boolean  "is_new",                   default: true
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
  end

  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "promotion_logs", force: :cascade do |t|
    t.string   "phone_number", limit: 255
    t.string   "mobile_type",  limit: 255, default: "unknow"
    t.integer  "c_id",         limit: 4
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "promotion_logs", ["c_id"], name: "index_promotion_logs_on_c_id", using: :btree

  create_table "shop_images", force: :cascade do |t|
    t.integer  "shop_id",    limit: 4
    t.integer  "image_id",   limit: 4
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "shop_images", ["image_id"], name: "index_shop_images_on_image_id", using: :btree
  add_index "shop_images", ["shop_id"], name: "index_shop_images_on_shop_id", using: :btree

  create_table "shop_promotion_logs", force: :cascade do |t|
    t.integer  "c_id",       limit: 4
    t.integer  "shop_id",    limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "shop_promotion_logs", ["c_id"], name: "index_shop_promotion_logs_on_c_id", using: :btree
  add_index "shop_promotion_logs", ["shop_id"], name: "index_shop_promotion_logs_on_shop_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "name",       limit: 255,                   null: false
    t.string   "address",    limit: 255,                   null: false
    t.string   "province",   limit: 255,                   null: false
    t.string   "city",       limit: 255,                   null: false
    t.string   "latitude",   limit: 255,                   null: false
    t.string   "longitude",  limit: 255,                   null: false
    t.string   "scale",      limit: 255
    t.string   "category",   limit: 255
    t.boolean  "deleted",                  default: false
    t.text     "desc",       limit: 65535
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
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
    t.integer  "likes",      limit: 4, default: 0
    t.integer  "rank",       limit: 4,             null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "twitter_images", ["image_id"], name: "fk_rails_dfbaf11298", using: :btree
  add_index "twitter_images", ["twitter_id"], name: "index_twitter_images_on_twitter_id", using: :btree

  create_table "twitters", force: :cascade do |t|
    t.text     "content",     limit: 65535
    t.integer  "author_id",   limit: 4,                     null: false
    t.integer  "designer_id", limit: 4,                     null: false
    t.string   "latitude",    limit: 255
    t.string   "longitude",   limit: 255
    t.integer  "image_count", limit: 4
    t.boolean  "deleted",                   default: false
    t.integer  "stars",       limit: 4,                     null: false
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
  end

  add_index "twitters", ["author_id"], name: "index_twitters_on_author_id", using: :btree
  add_index "twitters", ["designer_id"], name: "index_twitters_on_designer_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",         limit: 255,                    null: false
    t.string   "gender",       limit: 255, default: "unknow"
    t.string   "phone_number", limit: 255,                    null: false
    t.integer  "image_id",     limit: 4
    t.integer  "vitality",     limit: 4,   default: 0
    t.string   "status",       limit: 255, default: "normal"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "users", ["image_id"], name: "fk_rails_47c7c64b36", using: :btree
  add_index "users", ["phone_number"], name: "index_users_on_phone_number", using: :btree

  create_table "vita_images", force: :cascade do |t|
    t.integer  "vita_id",    limit: 4, null: false
    t.integer  "image_id",   limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "vita_images", ["image_id"], name: "fk_rails_0f2b6df185", using: :btree
  add_index "vita_images", ["vita_id"], name: "index_vita_images_on_vita_id", using: :btree

  create_table "vitae", force: :cascade do |t|
    t.integer  "designer_id", limit: 4,     null: false
    t.text     "desc",        limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "vitae", ["designer_id"], name: "index_vitae_on_designer_id", using: :btree

  add_foreign_key "account_logs", "accounts"
  add_foreign_key "account_logs", "users", column: "from_user"
  add_foreign_key "account_logs", "users", column: "to_user"
  add_foreign_key "accounts", "users"
  add_foreign_key "ad_images", "images"
  add_foreign_key "commissioners", "images", column: "code_image_id"
  add_foreign_key "designer_called_logs", "designers"
  add_foreign_key "designer_called_logs", "users"
  add_foreign_key "designers", "shops"
  add_foreign_key "designers", "users"
  add_foreign_key "favorite_designers", "designers"
  add_foreign_key "favorite_designers", "users"
  add_foreign_key "favorite_images", "images"
  add_foreign_key "favorite_images", "twitters"
  add_foreign_key "favorite_images", "users"
  add_foreign_key "images", "images", column: "original_image_id"
  add_foreign_key "login_users", "users"
  add_foreign_key "messages", "users"
  add_foreign_key "promotion_logs", "commissioners", column: "c_id"
  add_foreign_key "shop_images", "images"
  add_foreign_key "shop_images", "shops"
  add_foreign_key "shop_promotion_logs", "commissioners", column: "c_id"
  add_foreign_key "shop_promotion_logs", "shops"
  add_foreign_key "twitter_images", "images"
  add_foreign_key "twitter_images", "twitters"
  add_foreign_key "twitters", "designers"
  add_foreign_key "twitters", "users", column: "author_id"
  add_foreign_key "users", "images"
  add_foreign_key "vita_images", "images"
  add_foreign_key "vita_images", "vitae", column: "vita_id"
  add_foreign_key "vitae", "designers"
end
