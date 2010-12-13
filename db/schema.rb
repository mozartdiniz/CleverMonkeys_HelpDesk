# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101208004345) do

  create_table "answers", :force => true do |t|
    t.string   "value"
    t.integer  "ticket_id"
    t.integer  "template_field_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.string   "subject",    :limit => 200
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments_files", :force => true do |t|
    t.integer  "comment_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.string   "file_updated_at"
    t.string   "cid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "countries", :force => true do |t|
    t.string   "name"
    t.string   "time_zone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "enterprises", :force => true do |t|
    t.string   "name",                             :limit => 45
    t.boolean  "is_your_company"
    t.string   "email",                            :limit => 100
    t.string   "phone_01",                         :limit => 45
    t.string   "phone_02",                         :limit => 45
    t.string   "other_email",                      :limit => 100
    t.boolean  "enabled"
    t.boolean  "send_ticket_mail_for_all_company"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "field_options", :force => true do |t|
    t.integer  "field_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "fields", :force => true do |t|
    t.string   "field_type",  :limit => 10
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "global_configurations", :force => true do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups_roles", :force => true do |t|
    t.integer  "group_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.string   "description",      :limit => 55
    t.string   "iso",              :limit => 6
    t.boolean  "default_language"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "log_works", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.integer  "time_spend"
    t.datetime "start_date"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "priorities", :force => true do |t|
    t.string   "description", :limit => 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights", :force => true do |t|
    t.string   "controller"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rights_roles", :force => true do |t|
    t.integer  "role_id"
    t.integer  "right_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "template_fields", :force => true do |t|
    t.integer  "template_id"
    t.integer  "field_id"
    t.string   "width",       :limit => 10
    t.integer  "field_order"
    t.string   "height",      :limit => 10
    t.boolean  "mandatory"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "templates", :force => true do |t|
    t.string   "name"
    t.boolean  "enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_files", :force => true do |t|
    t.integer  "ticket_id"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.string   "file_file_size"
    t.string   "file_updated_at"
    t.string   "cid"
    t.integer  "file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_notes", :force => true do |t|
    t.integer  "ticket_id"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_notification_users", :force => true do |t|
    t.integer  "ticket_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_statuses", :force => true do |t|
    t.string   "description", :limit => 45
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ticket_types", :force => true do |t|
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", :force => true do |t|
    t.integer  "enterprise_id"
    t.integer  "user_id"
    t.integer  "ticket_status_id"
    t.integer  "priority_id"
    t.integer  "ticket_type_id"
    t.integer  "ticket_number"
    t.string   "subject"
    t.text     "issue_description"
    t.integer  "assigned_user_id"
    t.datetime "due_date"
    t.integer  "created_by_id"
    t.integer  "template_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets_defaults", :force => true do |t|
    t.integer  "enterprise_id"
    t.integer  "di_os_version"
    t.integer  "di_database_info"
    t.integer  "rts_database_info"
    t.integer  "rts_versions_id"
    t.string   "language_id",       :limit => 4
    t.string   "di_version",        :limit => 100
    t.string   "device_version",    :limit => 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "translations", :force => true do |t|
    t.integer  "resource_id"
    t.integer  "language_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name",               :limit => 55
    t.string   "display_name",       :limit => 40
    t.string   "phone_number",       :limit => 25
    t.string   "mobile_number",      :limit => 25
    t.string   "email"
    t.string   "hashed_password",                  :null => false
    t.string   "salt",                             :null => false
    t.integer  "group_id"
    t.integer  "language_id"
    t.integer  "enterprise_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.string   "photo_file_size"
    t.string   "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
