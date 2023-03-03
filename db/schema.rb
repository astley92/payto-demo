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

ActiveRecord::Schema[7.0].define(version: 2023_03_04_230348) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_enum :agreement_states, [
    "awaiting_approval",
    "declined",
    "accepted",
  ], force: :cascade

  create_enum :payment_states, [
    "processing",
    "failed",
    "settled",
  ], force: :cascade

  create_enum :purchases_state, [
    "created",
    "pending_consent",
    "payment_processing",
    "complete",
    "consent_failed",
    "payment_failed",
  ], force: :cascade

  create_table "agreements", force: :cascade do |t|
    t.enum "state", null: false, enum_type: "agreement_states"
    t.bigint "purchase_id", null: false
    t.string "zepto_agreement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["purchase_id"], name: "index_agreements_on_purchase_id"
  end

  create_table "items", force: :cascade do |t|
    t.string "title", null: false
    t.integer "price_cents", null: false
    t.string "image_filename", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.enum "state", null: false, enum_type: "payment_states"
    t.bigint "agreement_id", null: false
    t.string "zepto_payment_id", null: false
    t.integer "amount", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["agreement_id"], name: "index_payments_on_agreement_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "account_name", null: false
    t.string "branch_code", null: false
    t.string "account_number", null: false
    t.enum "state", enum_type: "purchases_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_purchases_on_item_id"
  end

  create_table "settlement_accounts", force: :cascade do |t|
    t.string "account_name", null: false
    t.string "account_number", null: false
    t.string "branch_code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "purchases", "items"
end
