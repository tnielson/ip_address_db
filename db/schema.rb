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

ActiveRecord::Schema.define(:version => 20090121115603) do

  create_table "attris", :force => true do |t|
    t.integer  "container_id", :null => false
    t.integer  "key_id",       :null => false
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "containers", :force => true do |t|
    t.integer  "type_id",    :null => false
    t.integer  "ipnet_id"
    t.integer  "parent_id"
    t.integer  "lft",        :null => false
    t.integer  "rgt",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",       :null => false
  end

  create_table "ipnets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ipaddr",                      :null => false
    t.string   "netmask",                     :null => false
    t.integer  "parent_id"
    t.integer  "lft",                         :null => false
    t.integer  "rgt",                         :null => false
    t.integer  "lock_version", :default => 0
    t.boolean  "unq"
    t.integer  "lvl",          :default => 0
    t.string   "description"
  end

  create_table "keys", :force => true do |t|
    t.string   "key_name",        :null => false
    t.string   "key_description", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "keys_types", :id => false, :force => true do |t|
    t.integer  "key_id"
    t.integer  "type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "permissions", :force => true do |t|
    t.integer  "role_id",                             :null => false
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "permission",      :default => "deny"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "role_name"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.string  "key"
    t.integer "value"
  end

  create_table "types", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userdatas", :force => true do |t|
    t.integer  "user_id",                                                                :null => false
    t.datetime "last_login"
    t.boolean  "deactivated",         :default => true
    t.string   "deactivation_reason", :default => "Account muss noch bestätigt werden"
    t.datetime "deactivation_date",   :default => '2009-01-22 16:25:14'
    t.integer  "default_startpage"
    t.string   "password1_salt"
    t.string   "password1_hash"
    t.string   "password2_salt"
    t.string   "password2_hash"
    t.string   "password3_salt"
    t.string   "password3_hash"
    t.datetime "password_updated_on", :default => '2009-01-22 16:25:14'
    t.integer  "password_faults",     :default => 0
    t.boolean  "navigation",          :default => false
  end

  create_table "users", :force => true do |t|
    t.string   "user_name"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "password_salt"
    t.string   "password_hash"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role_id",       :null => false
    t.string   "behoerde"
  end

end
