# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 34) do

  create_table "blogposts", :force => true do |t|
    t.column "body",       :text,                   :default => "",      :null => false
    t.column "created_on", :datetime
    t.column "user",       :string,   :limit => 45, :default => "dstar", :null => false
    t.column "title",      :text
    t.column "updated_on", :datetime
  end

  create_table "chapters", :force => true do |t|
    t.column "story_id",      :integer, :limit => 10, :default => 0,       :null => false
    t.column "number",        :integer, :limit => 10, :default => 0,       :null => false
    t.column "words",         :integer, :limit => 10, :default => 0,       :null => false
    t.column "date_uploaded", :date
    t.column "file",          :string,  :limit => 45, :default => "",      :null => false
    t.column "status",        :string,                :default => "draft"
    t.column "last_state",    :string
    t.column "last_status",   :string
    t.column "released",      :string
    t.column "date_released", :date
  end

  add_index "chapters", ["story_id", "number"], :name => "chap_uniq", :unique => true

  create_table "credits", :force => true do |t|
    t.column "user_id",     :integer, :default => 0,        :null => false
    t.column "story_id",    :integer, :default => 0,        :null => false
    t.column "credit_type", :string,  :default => "Author", :null => false
  end

  create_table "groups", :id => false, :force => true do |t|
    t.column "group_id",          :integer, :limit => 8,  :default => 0,     :null => false
    t.column "group_type",        :integer, :limit => 4,  :default => 0,     :null => false
    t.column "group_name",        :string,  :limit => 40, :default => "",    :null => false
    t.column "group_description", :string,                :default => "",    :null => false
    t.column "group_moderator",   :integer, :limit => 8,  :default => 0,     :null => false
    t.column "group_single_user", :boolean,               :default => false, :null => false
  end

  create_table "memberships", :id => false, :force => true do |t|
    t.column "group_id",     :integer, :limit => 8, :default => 0, :null => false
    t.column "user_id",      :integer, :limit => 8, :default => 0, :null => false
    t.column "user_pending", :boolean
  end

  create_table "paragraphs", :force => true do |t|
    t.column "chapter_id", :integer, :limit => 10, :default => 0,  :null => false
    t.column "body",       :text,                  :default => "", :null => false
    t.column "position",   :integer, :limit => 10, :default => 1,  :null => false
    t.column "flag",       :integer, :limit => 10, :default => 0,  :null => false
    t.column "body_raw",   :text
  end

  add_index "paragraphs", ["chapter_id"], :name => "chapter_index"

  create_table "pcomments", :force => true do |t|
    t.column "paragraph_id", :integer,  :limit => 10, :default => 0,         :null => false
    t.column "body",         :text,                   :default => "",        :null => false
    t.column "created_at",   :datetime
    t.column "username",     :string,   :limit => 45, :default => "no user", :null => false
    t.column "flag",         :integer,  :limit => 10, :default => 0,         :null => false
    t.column "read_by",      :text
    t.column "acknowledged", :string
  end

  add_index "pcomments", ["paragraph_id"], :name => "pcomments_paragraph_id_index"

  create_table "php_sessions", :force => true do |t|
    t.column "session_id",        :string,  :limit => 32, :default => "",    :null => false
    t.column "session_user_id",   :integer, :limit => 8,  :default => 0,     :null => false
    t.column "session_start",     :integer,               :default => 0,     :null => false
    t.column "session_time",      :integer,               :default => 0,     :null => false
    t.column "session_ip",        :string,  :limit => 8,  :default => "",    :null => false
    t.column "session_page",      :integer,               :default => 0,     :null => false
    t.column "session_logged_in", :boolean,               :default => false, :null => false
    t.column "session_admin",     :integer, :limit => 2,  :default => 0,     :null => false
  end

  create_table "sessions", :force => true do |t|
    t.column "sessid",     :string
    t.column "data",       :text
    t.column "updated_at", :datetime
  end

  add_index "sessions", ["sessid"], :name => "session_index"

  create_table "site_permissions", :force => true do |t|
    t.column "user_id",                :integer
    t.column "permission",             :string
    t.column "permission_holder_id",   :integer
    t.column "permission_holder_type", :string
  end

  create_table "sites", :force => true do |t|
    t.column "required_permissions",   :string
    t.column "available_permissions",  :string
    t.column "available_actions",      :string
    t.column "available_story_states", :string
    t.column "default_permit",         :string
  end

  create_table "stories", :force => true do |t|
    t.column "title",                        :string,                :default => "",      :null => false
    t.column "description",                  :text,                  :default => "",      :null => false
    t.column "flag",                         :integer, :limit => 10, :default => 0,       :null => false
    t.column "universe_id",                  :integer, :limit => 10, :default => 0,       :null => false
    t.column "short_title",                  :string,  :limit => 45, :default => "",      :null => false
    t.column "order",                        :integer, :limit => 10, :default => 0,       :null => false
    t.column "file_prefix",                  :string,  :limit => 45, :default => "",      :null => false
    t.column "status",                       :string,                :default => "draft"
    t.column "keywords",                     :string
    t.column "on_release",                   :string
    t.column "required_chapter_permissions", :string
    t.column "required_permission",          :string
  end

  create_table "story_permissions", :force => true do |t|
    t.column "permission_holder_id",   :integer
    t.column "permission_holder_type", :string
    t.column "story_id",               :integer
    t.column "permission",             :string
  end

  add_index "story_permissions", ["story_id"], :name => "story_permissions_story_id_index"
  add_index "story_permissions", ["permission_holder_id"], :name => "story_permissions_permission_holder_id_index"

  create_table "styles", :force => true do |t|
    t.column "element",    :text,                 :default => "", :null => false
    t.column "definition", :text,                 :default => "", :null => false
    t.column "theme",      :text,                 :default => "", :null => false
    t.column "user",       :integer, :limit => 8, :default => 0,  :null => false
  end

  create_table "targets", :force => true do |t|
    t.column "story_id",     :integer, :limit => 10, :default => 0,    :null => false
    t.column "month",        :integer, :limit => 10, :default => 0,    :null => false
    t.column "year",         :integer, :limit => 10, :default => 0,    :null => false
    t.column "weekly_words", :integer, :limit => 10, :default => 2000, :null => false
  end

  create_table "universe_permissions", :force => true do |t|
    t.column "permission_holder_id",   :integer
    t.column "permission_holder_type", :string
    t.column "universe_id",            :integer
    t.column "permission",             :string
  end

  create_table "universes", :force => true do |t|
    t.column "name",        :string,  :limit => 45, :default => "", :null => false
    t.column "description", :text,                  :default => "", :null => false
    t.column "flag",        :integer, :limit => 10, :default => 0,  :null => false
    t.column "status",      :string
  end

  create_table "users", :id => false, :force => true do |t|
    t.column "user_id",                 :integer, :limit => 8,   :default => 0,     :null => false
    t.column "user_active",             :boolean
    t.column "username",                :string,  :limit => 25,  :default => "",    :null => false
    t.column "user_password",           :string,  :limit => 32,  :default => "",    :null => false
    t.column "user_session_time",       :integer,                :default => 0,     :null => false
    t.column "user_session_page",       :integer, :limit => 5,   :default => 0,     :null => false
    t.column "user_lastvisit",          :integer,                :default => 0,     :null => false
    t.column "user_lastvisit_chat",     :integer,                :default => 0,     :null => false
    t.column "user_regdate",            :integer,                :default => 0,     :null => false
    t.column "user_level",              :integer, :limit => 4
    t.column "user_posts",              :integer, :limit => 8,   :default => 0,     :null => false
    t.column "user_timezone",           :float,   :limit => 5,   :default => 0.0,   :null => false
    t.column "user_style",              :integer, :limit => 4
    t.column "user_lang",               :string
    t.column "user_dateformat",         :string,  :limit => 14,  :default => "",    :null => false
    t.column "user_new_privmsg",        :integer, :limit => 5,   :default => 0,     :null => false
    t.column "user_unread_privmsg",     :integer, :limit => 5,   :default => 0,     :null => false
    t.column "user_last_privmsg",       :integer,                :default => 0,     :null => false
    t.column "user_emailtime",          :integer
    t.column "user_viewemail",          :boolean
    t.column "user_attachsig",          :boolean
    t.column "user_setbm",              :boolean,                :default => false, :null => false
    t.column "user_allowhtml",          :boolean
    t.column "user_allowbbcode",        :boolean
    t.column "user_allowsmile",         :boolean
    t.column "user_allowavatar",        :boolean,                :default => false, :null => false
    t.column "user_allow_pm",           :boolean,                :default => false, :null => false
    t.column "user_allow_viewonline",   :boolean,                :default => false, :null => false
    t.column "user_notify",             :boolean,                :default => false, :null => false
    t.column "user_notify_pm",          :boolean,                :default => false, :null => false
    t.column "user_popup_pm",           :boolean,                :default => false, :null => false
    t.column "user_rank",               :integer
    t.column "user_avatar",             :string,  :limit => 100
    t.column "user_avatar_type",        :integer, :limit => 4,   :default => 0,     :null => false
    t.column "user_email",              :string
    t.column "user_icq",                :string,  :limit => 15
    t.column "user_website",            :string,  :limit => 100
    t.column "user_from",               :string,  :limit => 100
    t.column "user_sig",                :text
    t.column "user_sig_bbcode_uid",     :string,  :limit => 10
    t.column "user_pips",               :text,                   :default => "",    :null => false
    t.column "user_pips_bbcode_uid",    :string,  :limit => 10,  :default => "",    :null => false
    t.column "user_pips_parsed",        :text,                   :default => "",    :null => false
    t.column "user_aim",                :string
    t.column "user_yim",                :string
    t.column "user_msnm",               :string
    t.column "user_occ",                :string,  :limit => 100
    t.column "user_skype",              :string,                 :default => "",    :null => false
    t.column "user_interests",          :string
    t.column "user_actkey",             :string,  :limit => 32
    t.column "user_newpasswd",          :string,  :limit => 32
    t.column "user_topic_view",         :string,  :limit => 0,   :default => "",    :null => false
    t.column "user_pubname",            :string
    t.column "user_thread_indent_px",   :integer, :limit => 6,   :default => 0,     :null => false
    t.column "user_thread_cutofflevel", :integer, :limit => 6,   :default => 0,     :null => false
    t.column "user_view_log",           :integer, :limit => 4,   :default => 0,     :null => false
    t.column "user_index_mode",         :boolean,                :default => false, :null => false
    t.column "user_unread_topics",      :text
    t.column "user_login_tries",        :integer, :limit => 5,   :default => 0,     :null => false
    t.column "user_last_login_try",     :integer,                :default => 0,     :null => false
  end

end
