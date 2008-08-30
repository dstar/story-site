# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 41) do

  create_table "blogposts", :force => true do |t|
    t.string   "user",       :limit => 45, :null => false
    t.text     "body",                     :null => false
    t.text     "title"
    t.datetime "updated_on"
    t.datetime "created_on"
    t.text     "body_raw"
  end

  create_table "chapters", :force => true do |t|
    t.integer  "story_id",      :default => 0,       :null => false
    t.integer  "number",        :default => 0,       :null => false
    t.integer  "words",         :default => 0,       :null => false
    t.string   "file",          :default => "",      :null => false
    t.string   "status",        :default => "draft"
    t.date     "date_uploaded"
    t.string   "last_state"
    t.string   "last_status"
    t.string   "released"
    t.date     "date_released"
    t.datetime "release_on"
  end

  add_index "chapters", ["story_id", "number"], :name => "chap_uniq", :unique => true

  create_table "commitments", :force => true do |t|
  end

  create_table "credits", :force => true do |t|
    t.string  "credit_type", :default => "Author", :null => false
    t.integer "user_id",                           :null => false
    t.integer "story_id",                          :null => false
  end

  create_table "donations", :force => true do |t|
    t.string "email"
    t.float  "amount"
    t.string "txn_id"
    t.date   "donation_date"
  end

  create_table "groups", :id => false, :force => true do |t|
    t.integer "group_type",        :default => 1,    :null => false
    t.string  "group_name",        :default => "",   :null => false
    t.string  "group_description", :default => "",   :null => false
    t.integer "group_moderator",   :default => 0,    :null => false
    t.boolean "group_single_user", :default => true, :null => false
    t.integer "group_id",                            :null => false
  end

  create_table "memberships", :id => false, :force => true do |t|
    t.integer "group_id",     :default => 0, :null => false
    t.integer "user_id",      :default => 0, :null => false
    t.boolean "user_pending"
  end

  create_table "paragraphs", :force => true do |t|
    t.integer "chapter_id", :default => 0, :null => false
    t.integer "position",   :default => 1, :null => false
    t.integer "flag",       :default => 0, :null => false
    t.text    "body",                      :null => false
    t.text    "body_raw"
  end

  add_index "paragraphs", ["chapter_id"], :name => "chapter_index"

  create_table "pcomments", :force => true do |t|
    t.integer  "paragraph_id", :default => 0,         :null => false
    t.string   "username",     :default => "no user", :null => false
    t.integer  "flag",         :default => 0,         :null => false
    t.text     "body",                                :null => false
    t.text     "read_by"
    t.string   "acknowledged"
    t.datetime "created_at"
    t.text     "body_raw"
  end

  add_index "pcomments", ["paragraph_id"], :name => "pcomments_paragraph_id_index"

  create_table "pcomments_read_by", :id => false, :force => true do |t|
    t.integer "pcomment_id", :null => false
    t.integer "user_id",     :null => false
  end

  add_index "pcomments_read_by", ["pcomment_id"], :name => "index_pcomments_read_by_on_pcomment_id"
  add_index "pcomments_read_by", ["user_id"], :name => "index_pcomments_read_by_on_user_id"

  create_table "php_sessions", :force => true do |t|
    t.string  "session_id",        :default => "",    :null => false
    t.integer "session_user_id",   :default => 0,     :null => false
    t.integer "session_start",     :default => 0,     :null => false
    t.integer "session_time",      :default => 0,     :null => false
    t.string  "session_ip",        :default => "0",   :null => false
    t.integer "session_page",      :default => 0,     :null => false
    t.boolean "session_logged_in", :default => false, :null => false
    t.integer "session_admin",     :default => 0,     :null => false
  end

  create_table "required_permissions", :force => true do |t|
    t.integer "permissionable_id"
    t.string  "permissionable_type"
    t.string  "status"
    t.string  "action"
    t.string  "permission"
  end

  create_table "sessions", :force => true do |t|
    t.string   "sessid"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["sessid"], :name => "session_index"

  create_table "site_permissions", :force => true do |t|
    t.integer "user_id"
    t.string  "permission"
    t.integer "permission_holder_id"
    t.string  "permission_holder_type"
  end

  create_table "sites", :force => true do |t|
    t.string "required_permissions"
    t.string "available_permissions"
    t.string "available_actions"
    t.string "available_story_states"
    t.string "default_permit"
  end

  create_table "stories", :force => true do |t|
    t.string  "title",                        :default => "",      :null => false
    t.integer "flag",                         :default => 0,       :null => false
    t.integer "universe_id",                  :default => 0,       :null => false
    t.string  "short_title",                  :default => "",      :null => false
    t.integer "order",                        :default => 0,       :null => false
    t.string  "file_prefix",                  :default => "",      :null => false
    t.string  "status",                       :default => "draft"
    t.text    "description",                                       :null => false
    t.string  "keywords"
    t.string  "on_release"
    t.string  "required_chapter_permissions"
    t.string  "required_permission"
  end

  create_table "story_permissions", :force => true do |t|
    t.integer "permission_holder_id"
    t.string  "permission_holder_type"
    t.integer "story_id"
    t.string  "permission"
  end

  add_index "story_permissions", ["story_id"], :name => "story_permissions_story_id_index"
  add_index "story_permissions", ["permission_holder_id"], :name => "story_permissions_permission_holder_id_index"

  create_table "styles", :force => true do |t|
    t.text    "element",    :null => false
    t.text    "definition", :null => false
    t.text    "theme",      :null => false
    t.integer "user",       :null => false
  end

  create_table "targets", :force => true do |t|
    t.integer "story_id",     :default => 0,    :null => false
    t.integer "month",        :default => 0,    :null => false
    t.integer "year",         :default => 0,    :null => false
    t.integer "weekly_words", :default => 2000, :null => false
  end

  create_table "universe_permissions", :force => true do |t|
    t.integer "permission_holder_id"
    t.string  "permission_holder_type"
    t.integer "universe_id"
    t.string  "permission"
  end

  create_table "universes", :force => true do |t|
    t.string  "name",        :default => "", :null => false
    t.integer "flag",        :default => 0,  :null => false
    t.text    "description",                 :null => false
    t.string  "status"
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer "user_id",                                                      :default => 0,           :null => false
    t.boolean "user_active",                                                  :default => true
    t.string  "username",                                                     :default => "",          :null => false
    t.string  "user_password",                                                :default => "",          :null => false
    t.integer "user_lastvisit",                                               :default => 0,           :null => false
    t.integer "user_regdate",                                                 :default => 0,           :null => false
    t.string  "user_dateformat",                                              :default => "d M Y H:i", :null => false
    t.decimal "user_timezone",                  :precision => 5, :scale => 2, :default => 0.0,         :null => false
    t.string  "user_email"
    t.string  "user_icq"
    t.string  "user_aim"
    t.string  "user_yim"
    t.string  "user_msnm"
    t.string  "user_website",    :limit => 100
    t.string  "user_actkey",     :limit => 32
    t.string  "user_newpasswd",  :limit => 32
  end

end
