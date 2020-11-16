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

ActiveRecord::Schema.define(version: 20201116070828) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "borutus_accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "type"
    t.boolean "contra"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "tenant_id"
    t.integer "amounts_count"
    t.index ["name", "type"], name: "index_borutus_accounts_on_name_and_type"
  end

  create_table "borutus_amounts", id: :serial, force: :cascade do |t|
    t.string "type"
    t.integer "account_id"
    t.integer "entry_id"
    t.decimal "amount"
    t.index ["account_id", "entry_id"], name: "index_borutus_amounts_on_account_id_and_entry_id"
    t.index ["entry_id", "account_id"], name: "index_borutus_amounts_on_entry_id_and_account_id"
    t.index ["type"], name: "index_borutus_amounts_on_type"
  end

  create_table "borutus_entries", id: :serial, force: :cascade do |t|
    t.string "description"
    t.date "date"
    t.integer "commercial_document_id"
    t.string "commercial_document_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commercial_document_id", "commercial_document_type"], name: "index_entries_on_commercial_doc"
    t.index ["date"], name: "index_borutus_entries_on_date"
  end

end
