# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_10_16_185453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "homes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "atrea_login"
    t.binary "atrea_password"
    t.binary "somfy_client_id"
    t.binary "somfy_secret"
    t.string "somfy_token"
    t.string "somfy_refresh_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "influxdb_options"
    t.jsonb "duplex_auth_options"
    t.jsonb "duplex_user_ctrl"
    t.index ["user_id"], name: "index_homes_on_user_id"
  end

  create_table "preferences", force: :cascade do |t|
    t.string "name", null: false
    t.string "value"
    t.string "type"
    t.boolean "restrict", default: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["name"], name: "index_preferences_on_name"
  end

  create_table "preferences_users", id: false, force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "preference_id"
    t.index ["preference_id"], name: "index_preferences_users_on_preference_id"
    t.index ["user_id", "preference_id"], name: "index_preferences_users_on_user_id_and_preference_id"
    t.index ["user_id"], name: "index_preferences_users_on_user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.jsonb "permissions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.boolean "admin", default: false, null: false
    t.integer "status", default: 1, null: false
    t.string "login", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "language"
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "single_access_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at", precision: nil
    t.datetime "current_login_at", precision: nil
    t.datetime "last_login_at", precision: nil
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.bigint "edited_by_id"
    t.datetime "edited_at", precision: nil
    t.bigint "role_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "external_id"
    t.uuid "uuid"
    t.string "avatar_url"
    t.index ["edited_by_id"], name: "index_users_on_edited_by_id"
    t.index ["perishable_token"], name: "index_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_users_on_persistence_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
    t.index ["single_access_token"], name: "index_users_on_single_access_token", unique: true
    t.index ["status"], name: "index_users_on_status"
  end

  add_foreign_key "homes", "users"
end
