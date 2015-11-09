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

ActiveRecord::Schema.define(version: 20151106021524) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "features", force: :cascade do |t|
    t.integer  "project_id",   null: false
    t.string   "title",        null: false
    t.integer  "status",       null: false
    t.integer  "priority"
    t.integer  "point"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "iteration_id"
  end

  add_index "features", ["project_id", "point"], name: "index_features_on_project_id_and_point", using: :btree
  add_index "features", ["project_id", "priority"], name: "index_features_on_project_id_and_priority", using: :btree
  add_index "features", ["project_id", "status"], name: "index_features_on_project_id_and_status", using: :btree
  add_index "features", ["project_id"], name: "index_features_on_project_id", using: :btree

  create_table "iterations", force: :cascade do |t|
    t.integer  "project_id", null: false
    t.integer  "number",     null: false
    t.date     "start_at",   null: false
    t.date     "end_at",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "iterations", ["project_id", "number"], name: "index_iterations_on_project_id_and_number", unique: true, using: :btree
  add_index "iterations", ["project_id"], name: "index_iterations_on_project_id", using: :btree

  create_table "members", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.integer  "project_id", null: false
    t.integer  "role",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "members", ["project_id"], name: "index_members_on_project_id", using: :btree
  add_index "members", ["user_id", "project_id"], name: "index_members_on_user_id_and_project_id", unique: true, using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",               limit: 50,              null: false
    t.string   "email",              limit: 100,             null: false
    t.string   "crypted_password",                           null: false
    t.string   "password_salt",                              null: false
    t.string   "persistence_token",                          null: false
    t.integer  "login_count",                    default: 0, null: false
    t.integer  "failed_login_count",             default: 0, null: false
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

end
