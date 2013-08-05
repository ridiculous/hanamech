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

ActiveRecord::Schema.define(version: 20130805010002) do

  create_table "cars", force: true do |t|
    t.string   "car_make"
    t.string   "car_model"
    t.integer  "year"
    t.string   "engine_size"
    t.string   "vin_number"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "email"
    t.string   "cell_number"
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
  end

  create_table "workorders", force: true do |t|
    t.string   "details"
    t.string   "materials"
    t.date     "date"
    t.string   "odometer"
    t.string   "parts"
    t.string   "labor"
    t.string   "tax"
    t.string   "total"
    t.integer  "car_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
