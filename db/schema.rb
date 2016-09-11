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

ActiveRecord::Schema.define(:version => 20111209161326) do

  create_table "administrative_documents", :force => true do |t|
    t.integer  "sport_community_membership_id",                    :null => false
    t.string   "document"
    t.string   "kind"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "accepted",                      :default => false, :null => false
    t.date     "valid_until"
  end

  add_index "administrative_documents", ["sport_community_membership_id"], :name => "index_administrative_documents_on_sport_community_membership_id"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.integer  "firm_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "domains", ["firm_id"], :name => "index_domains_on_firm_id"
  add_index "domains", ["name"], :name => "index_domains_on_name", :unique => true

  create_table "employees", :force => true do |t|
    t.integer  "firm_id"
    t.string   "email",                  :default => "", :null => false
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "work_council_group_id"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  create_table "events", :force => true do |t|
    t.integer  "sport_id"
    t.string   "name"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.text     "description"
    t.text     "short_description"
    t.string   "target"
    t.string   "nature"
    t.string   "kind"
    t.string   "game_kind"
    t.string   "player_category"
    t.text     "participation_terms"
    t.integer  "max_players_count"
    t.integer  "max_team_players_count"
    t.string   "venue_name"
    t.string   "venue_phone"
    t.string   "venue_address"
    t.string   "venue_zip_code"
    t.string   "venue_city"
    t.string   "venue_country"
    t.text     "travel_informations"
    t.string   "arrival_address"
    t.string   "arrival_zip_code"
    t.string   "arrival_city"
    t.string   "arrival_country"
    t.string   "scale"
    t.string   "website_url"
    t.string   "brochure_image"
    t.string   "registration_strategy"
    t.text     "payment_terms"
    t.date     "registration_starts_on"
    t.date     "registration_ends_on"
    t.string   "registration_email"
    t.text     "registration_mail"
    t.text     "practical_informations"
    t.string   "organizer_name"
    t.string   "organizer_contact"
    t.string   "organizer_phone"
    t.string   "organizer_email"
    t.string   "organizer_address"
    t.string   "organizer_zip_code"
    t.string   "organizer_city"
    t.string   "organizer_rib"
    t.date     "broadcast_starts_on"
    t.date     "broadcast_ends_on"
    t.boolean  "featured"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "pfs_registration_ends_on"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "events", ["sport_id"], :name => "index_events_on_sport_id"

  create_table "firms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "address"
    t.string   "logo"
    t.string   "basecolor_color"
    t.string   "complement_color"
  end

  create_table "golf_courses", :force => true do |t|
    t.integer  "infrastructure_id"
    t.string   "name"
    t.integer  "holes_count"
    t.integer  "par"
    t.integer  "length",            :default => 0
    t.integer  "white_slope"
    t.integer  "yellow_slope"
    t.integer  "red_slope"
    t.integer  "blue_slope"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "golf_courses", ["infrastructure_id"], :name => "index_golf_courses_on_infrastructure_id"

  create_table "import_discards", :force => true do |t|
    t.integer  "import_id"
    t.string   "identifier"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_discards", ["import_id"], :name => "index_employees_import_discards_on_employees_import_id"
  add_index "import_discards", ["import_id"], :name => "index_import_discards_on_import_id"

  create_table "imports", :force => true do |t|
    t.integer  "created_count", :default => 0
    t.integer  "updated_count", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
  end

  create_table "infrastructures", :force => true do |t|
    t.integer  "sport_id",               :null => false
    t.string   "kind"
    t.string   "name",                   :null => false
    t.string   "display_name",           :null => false
    t.string   "logo"
    t.text     "hq_address"
    t.string   "hq_zip_code"
    t.string   "hq_city"
    t.string   "hq_country"
    t.string   "hq_phone"
    t.string   "hq_mobile"
    t.string   "hq_fax"
    t.string   "hq_email"
    t.string   "hq_url"
    t.string   "contact_name"
    t.string   "contact_role"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.string   "rib_bank"
    t.string   "rib_office"
    t.string   "rib_account"
    t.string   "rib_key"
    t.string   "rib_owner_name"
    t.text     "rib_owner_address"
    t.string   "iban"
    t.string   "bic"
    t.string   "venue_name"
    t.text     "venue_address"
    t.string   "venue_zip_code"
    t.string   "venue_city"
    t.string   "venue_country"
    t.text     "practical_informations"
    t.text     "opening_hours"
    t.text     "equipments"
    t.text     "other_comments"
    t.text     "geengo_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "accessible"
    t.string   "picture_1"
    t.string   "picture_2"
    t.string   "picture_3"
    t.string   "type"
    t.float    "latitude"
    t.float    "longitude"
  end

  add_index "infrastructures", ["sport_id"], :name => "index_infrastructures_on_sport_id"

  create_table "messages", :force => true do |t|
    t.integer  "sport_community_id"
    t.integer  "employee_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ancestry"
    t.string   "commentable_type"
    t.integer  "commentable_id"
  end

  add_index "messages", ["ancestry"], :name => "index_messages_on_ancestry"
  add_index "messages", ["employee_id"], :name => "index_messages_on_employee_id"
  add_index "messages", ["sport_community_id"], :name => "index_messages_on_sport_community_id"

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id"], :name => "index_roles_users_on_role_id"
  add_index "roles_users", ["user_id"], :name => "index_roles_users_on_user_id"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.integer  "purchasable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "purchasable_type"
    t.string   "purchasable_type_and_id"
  end

  add_index "services", ["purchasable_id"], :name => "index_services_on_infrastructure_id"

  create_table "sport_communities", :force => true do |t|
    t.integer  "firm_id",    :null => false
    t.integer  "sport_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sport_communities", ["firm_id"], :name => "index_sport_communities_on_firm_id"
  add_index "sport_communities", ["sport_id"], :name => "index_sport_communities_on_sport_id"

  create_table "sport_community_memberships", :force => true do |t|
    t.integer  "employee_id",                        :null => false
    t.integer  "sport_community_id",                 :null => false
    t.string   "level"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "ranking"
    t.string   "licence_number"
    t.string   "position"
    t.string   "name",               :default => "", :null => false
  end

  add_index "sport_community_memberships", ["employee_id"], :name => "index_sport_community_memberships_on_employee_id"
  add_index "sport_community_memberships", ["sport_community_id"], :name => "index_sport_community_memberships_on_sport_community_id"

  create_table "sports", :force => true do |t|
    t.string   "name",       :null => false
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sports", ["name"], :name => "index_sports_on_name", :unique => true

  create_table "sub_services", :force => true do |t|
    t.string   "name"
    t.integer  "service_id"
    t.decimal  "price",               :default => 0.0
    t.decimal  "discount",            :default => 0.0
    t.text     "eligible_conditions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sub_services", ["service_id"], :name => "index_sub_services_on_service_id"

  create_table "users", :force => true do |t|
    t.integer  "firm_id"
    t.string   "email",                  :default => "", :null => false
    t.string   "department"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "work_council_group_id"
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "type"
    t.string   "photo"
    t.date     "date_of_birth"
    t.string   "address"
    t.string   "mobile"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "infrastructure_id"
    t.string   "zip_code"
    t.string   "city"
  end

  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["email"], :name => "index_employees_on_email", :unique => true
  add_index "users", ["infrastructure_id"], :name => "index_users_on_infrastructure_id"
  add_index "users", ["reset_password_token"], :name => "index_employees_on_reset_password_token", :unique => true
  add_index "users", ["work_council_group_id"], :name => "index_employees_on_work_council_group_id"

  create_table "work_council_groups", :force => true do |t|
    t.integer  "work_council_id"
    t.integer  "discount_percentage",          :default => 0,   :null => false
    t.decimal  "annual_discount_ceiling",      :default => 0.0
    t.decimal  "transaction_discount_ceiling", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "work_council_groups", ["work_council_id", "name"], :name => "index_work_council_groups_on_work_council_id_and_name", :unique => true
  add_index "work_council_groups", ["work_council_id"], :name => "index_work_council_groups_on_work_council_id"

  create_table "work_councils", :force => true do |t|
    t.integer  "firm_id",                                  :null => false
    t.decimal  "annual_discount_ceiling", :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "work_councils", ["firm_id"], :name => "index_work_councils_on_firm_id", :unique => true

end
