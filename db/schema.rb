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

ActiveRecord::Schema.define(version: 20131231014440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cars", force: true do |t|
    t.string   "car_make"
    t.string   "car_model"
    t.integer  "year"
    t.string   "engine_size"
    t.string   "vin_number"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "year_make_model"
    t.integer  "odometer"
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "cell_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "street"
    t.string   "city_state"
    t.string   "name"
  end

  create_table "jobs", force: true do |t|
    t.string   "name"
    t.string   "hours"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "parts", force: true do |t|
    t.string   "name"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "last_login"
    t.boolean  "luna"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "auth_token"
    t.integer  "customer_id"
  end

  create_table "workorder_jobs", force: true do |t|
    t.integer  "workorder_id", null: false
    t.integer  "job_id",       null: false
    t.string   "total"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "hours"
  end

  create_table "workorder_parts", force: true do |t|
    t.integer  "part_id"
    t.integer  "workorder_id"
    t.float    "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
  end

  create_table "workorders", force: true do |t|
    t.string   "details"
    t.string   "materials"
    t.date     "date"
    t.string   "odometer"
    t.string   "parts_total"
    t.string   "labor"
    t.string   "tax"
    t.string   "total"
    t.integer  "car_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "misc_supplies"
    t.string   "sublet_repairs"
    t.string   "paid_in_advance"
    t.float    "labor_total"
    t.float    "tax_total"
    t.float    "balance_due"
  end

end
