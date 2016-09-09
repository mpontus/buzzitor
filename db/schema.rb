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

ActiveRecord::Schema.define(version: 20160813120236) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "monitoring_contexts", force: :cascade do |t|
    t.string   "url"
    t.datetime "fetched_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monitoring_results", force: :cascade do |t|
    t.integer  "context_id"
    t.text     "title"
    t.text     "content"
    t.binary   "screenshot"
    t.integer  "error_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_id"], name: "index_monitoring_results_on_context_id", using: :btree
  end

  create_table "monitoring_subscribers", force: :cascade do |t|
    t.integer "context_id"
    t.string  "endpoint",   null: false
    t.json    "keys",       null: false
    t.index ["context_id", "endpoint"], name: "index_monitoring_subscribers_on_context_id_and_endpoint", unique: true, using: :btree
    t.index ["context_id"], name: "index_monitoring_subscribers_on_context_id", using: :btree
  end

  add_foreign_key "monitoring_results", "monitoring_contexts", column: "context_id"
  add_foreign_key "monitoring_subscribers", "monitoring_contexts", column: "context_id"
end
