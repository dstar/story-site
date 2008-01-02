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

ActiveRecord::Schema.define(:version => 40) do

  create_table "blogposts", :force => true do |t|
    t.text     "body",                     :default => "",      :null => false
    t.datetime "created_on"
    t.string   "user",       :limit => 45, :default => "dstar", :null => false
    t.text     "title"
    t.datetime "updated_on"
    t.text     "body_raw"
  end

  create_table "chapters", :force => true do |t|
    t.integer  "story_id",      :limit => 10, :default => 0,       :null => false
    t.integer  "number",        :limit => 10, :default => 0,       :null => false
    t.integer  "words",         :limit => 10, :default => 0,       :null => false
    t.date     "date_uploaded"
    t.string   "file",          :limit => 45, :default => "",      :null => false
    t.string   "status",                      :default => "draft"
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
    t.integer "user_id",                           :null => false
    t.integer "story_id",                          :null => false
    t.string  "credit_type", :default => "Author", :null => false
  end

  create_table "donations", :force => true do |t|
    t.string "email"
    t.float  "amount"
    t.string "txn_id"
    t.date   "donation_date"
  end

  create_table "groups", :id => false, :force => true do |t|
    t.integer "group_id",          :limit => 8,  :default => 0,     :null => false
    t.integer "group_type",        :limit => 4,  :default => 0,     :null => false
    t.string  "group_name",        :limit => 40, :default => "",    :null => false
    t.string  "group_description",               :default => "",    :null => false
    t.integer "group_moderator",   :limit => 8,  :default => 0,     :null => false
    t.boolean "group_single_user",               :default => false, :null => false
  end

  create_table "memberships", :id => false, :force => true do |t|
    t.integer "group_id",     :limit => 8, :default => 0, :null => false
    t.integer "user_id",      :limit => 8, :default => 0, :null => false
    t.boolean "user_pending"
  end

  create_table "paragraphs", :force => true do |t|
    t.integer "chapter_id", :limit => 10, :default => 0,  :null => false
    t.text    "body",                     :default => "", :null => false
    t.integer "position",   :limit => 10, :default => 1,  :null => false
    t.integer "flag",       :limit => 10, :default => 0,  :null => false
    t.text    "body_raw"
  end

  add_index "paragraphs", ["chapter_id"], :name => "chapter_index"

  create_table "pcomments", :force => true do |t|
    t.integer  "paragraph_id", :limit => 10, :default => 0,         :null => false
    t.text     "body",                       :default => "",        :null => false
    t.datetime "created_at"
    t.string   "username",     :limit => 45, :default => "no user", :null => false
    t.integer  "flag",         :limit => 10, :default => 0,         :null => false
    t.text     "read_by"
    t.string   "acknowledged"
    t.text     "body_raw"
  end

  add_index "pcomments", ["paragraph_id"], :name => "pcomments_paragraph_id_index"

  create_table "php_sessions", :force => true do |t|
    t.string  "session_id",        :limit => 32, :default => "",    :null => false
    t.integer "session_user_id",   :limit => 8,  :default => 0,     :null => false
    t.integer "session_start",                   :default => 0,     :null => false
    t.integer "session_time",                    :default => 0,     :null => false
    t.string  "session_ip",        :limit => 8,  :default => "",    :null => false
    t.integer "session_page",                    :default => 0,     :null => false
    t.boolean "session_logged_in",               :default => false, :null => false
    t.integer "session_admin",     :limit => 2,  :default => 0,     :null => false
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
    t.string  "title",                                      :default => "",      :null => false
    t.text    "description",                                :default => "",      :null => false
    t.integer "flag",                         :limit => 10, :default => 0,       :null => false
    t.integer "universe_id",                  :limit => 10, :default => 0,       :null => false
    t.string  "short_title",                  :limit => 45, :default => "",      :null => false
    t.integer "order",                        :limit => 10, :default => 0,       :null => false
    t.string  "file_prefix",                  :limit => 45, :default => "",      :null => false
    t.string  "status",                                     :default => "draft"
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
    t.text    "element",                 :default => "", :null => false
    t.text    "definition",              :default => "", :null => false
    t.text    "theme",                   :default => "", :null => false
    t.integer "user",       :limit => 8,                 :null => false
  end

  create_table "targets", :force => true do |t|
    t.integer "story_id",     :limit => 10, :default => 0,    :null => false
    t.integer "month",        :limit => 10, :default => 0,    :null => false
    t.integer "year",         :limit => 10, :default => 0,    :null => false
    t.integer "weekly_words", :limit => 10, :default => 2000, :null => false
  end

  create_table "universe_permissions", :force => true do |t|
    t.integer "permission_holder_id"
    t.string  "permission_holder_type"
    t.integer "universe_id"
    t.string  "permission"
  end

  create_table "universes", :force => true do |t|
    t.string  "name",        :limit => 45, :default => "", :null => false
    t.text    "description",               :default => "", :null => false
    t.integer "flag",        :limit => 10, :default => 0,  :null => false
    t.string  "status"
  end

  create_table "users", :id => false, :force => true do |t|
    t.integer "user_id",                 :limit => 8,                                 :default => 0,     :null => false
    t.boolean "user_active"
    t.string  "username",                :limit => 25,                                :default => "",    :null => false
    t.string  "user_password",           :limit => 32,                                :default => "",    :null => false
    t.integer "user_session_time",                                                    :default => 0,     :null => false
    t.integer "user_session_page",       :limit => 5,                                 :default => 0,     :null => false
    t.integer "user_lastvisit",                                                       :default => 0,     :null => false
    t.integer "user_lastvisit_chat",                                                  :default => 0,     :null => false
    t.integer "user_regdate",                                                         :default => 0,     :null => false
    t.integer "user_level",              :limit => 4
    t.integer "user_posts",              :limit => 8,                                 :default => 0,     :null => false
    t.decimal "user_timezone",                          :precision => 5, :scale => 2, :default => 0.0,   :null => false
    t.integer "user_style",              :limit => 4
    t.string  "user_lang"
    t.string  "user_dateformat",         :limit => 14,                                :default => "",    :null => false
    t.integer "user_new_privmsg",        :limit => 5,                                 :default => 0,     :null => false
    t.integer "user_unread_privmsg",     :limit => 5,                                 :default => 0,     :null => false
    t.integer "user_last_privmsg",                                                    :default => 0,     :null => false
    t.integer "user_emailtime"
    t.boolean "user_viewemail"
    t.boolean "user_attachsig"
    t.boolean "user_setbm",                                                           :default => false, :null => false
    t.boolean "user_allowhtml"
    t.boolean "user_allowbbcode"
    t.boolean "user_allowsmile"
    t.boolean "user_allowavatar",                                                     :default => false, :null => false
    t.boolean "user_allow_pm",                                                        :default => false, :null => false
    t.boolean "user_allow_viewonline",                                                :default => false, :null => false
    t.boolean "user_notify",                                                          :default => false, :null => false
    t.boolean "user_notify_pm",                                                       :default => false, :null => false
    t.boolean "user_popup_pm",                                                        :default => false, :null => false
    t.integer "user_rank"
    t.string  "user_avatar",             :limit => 100
    t.integer "user_avatar_type",        :limit => 4,                                 :default => 0,     :null => false
    t.string  "user_email"
    t.string  "user_icq",                :limit => 15
    t.string  "user_website",            :limit => 100
    t.string  "user_from",               :limit => 100
    t.text    "user_sig"
    t.string  "user_sig_bbcode_uid",     :limit => 10
    t.text    "user_pips",                                                            :default => "",    :null => false
    t.string  "user_pips_bbcode_uid",    :limit => 10,                                :default => "",    :null => false
    t.text    "user_pips_parsed",                                                     :default => "",    :null => false
    t.string  "user_aim"
    t.string  "user_yim"
    t.string  "user_msnm"
    t.string  "user_occ",                :limit => 100
    t.string  "user_skype",                                                           :default => "",    :null => false
    t.string  "user_interests"
    t.string  "user_actkey",             :limit => 32
    t.string  "user_newpasswd",          :limit => 32
    t.string  "user_topic_view",         :limit => 0,                                 :default => "",    :null => false
    t.string  "user_pubname"
    t.integer "user_thread_indent_px",   :limit => 6,                                 :default => 0,     :null => false
    t.integer "user_thread_cutofflevel", :limit => 6,                                 :default => 0,     :null => false
    t.integer "user_view_log",           :limit => 4,                                 :default => 0,     :null => false
    t.boolean "user_index_mode",                                                      :default => false, :null => false
    t.text    "user_unread_topics"
    t.integer "user_login_tries",        :limit => 5,                                 :default => 0,     :null => false
    t.integer "user_last_login_try",                                                  :default => 0,     :null => false
  end

end
