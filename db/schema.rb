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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20160131085158) do

  create_table "bugger_job_results", :force => true do |t|
    t.integer  "bugger_job_id", :null => false
    t.string   "product_ref"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "bugger_job_results", ["bugger_job_id"], :name => "index_bugger_job_results_on_bugger_job_id"
  add_index "bugger_job_results", ["product_ref"], :name => "index_bugger_job_results_on_product_ref"

  create_table "bugger_jobs", :force => true do |t|
    t.string   "state",          :null => false
    t.integer  "delayed_job_id"
    t.datetime "completed_at"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "bugger_jobs", ["state"], :name => "index_bugger_jobs_on_state"

  create_table "data_errors", :force => true do |t|
    t.integer  "bugger_job_result_id", :null => false
    t.string   "key",                  :null => false
    t.string   "type",                 :null => false
    t.string   "expected_value"
    t.string   "actual_value"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "data_errors", ["bugger_job_result_id"], :name => "index_data_errors_on_bugger_job_result_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0, :null => false
    t.integer  "attempts",   :default => 0, :null => false
    t.text     "handler",                   :null => false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "file_attachments", :force => true do |t|
    t.integer  "row_id"
    t.string   "row_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "file_attachments", ["row_id", "row_type"], :name => "index_file_attachments_on_row_id_and_row_type"

  create_table "photos", :force => true do |t|
    t.integer  "row_id"
    t.string   "row_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
  end

  add_index "photos", ["row_id", "row_type"], :name => "index_photos_on_row_id_and_row_type"

end
