class CreateInfrastructures < ActiveRecord::Migration
  def change
    create_table :infrastructures do |t|
      t.belongs_to :sport, :null => false
      t.string :kind
      t.string :full_name, :null => false
      t.string :short_name
      t.string :logo

      t.text :hq_address
      t.string :hq_zip_code
      t.string :hq_city
      t.string :hq_country
      t.string :hq_phone
      t.string :hq_mobile
      t.string :hq_fax
      t.string :hq_email
      t.string :hq_url

      t.string :contact_name
      t.string :contact_role
      t.string :contact_phone
      t.string :contact_email

      t.string :rib_bank
      t.string :rib_office
      t.string :rib_account
      t.string :rib_key
      t.string :rib_owner_name
      t.text :rib_owner_address
      t.string :iban
      t.string :bic

      t.string :venue_name
      t.text :venue_address
      t.string :venue_zip_code
      t.string :venue_city
      t.string :venue_country

      t.text :complementary_informations
      t.text :opening_hours
      t.text :equipments
      t.text :comments
      t.text :geengo_comments

      t.timestamps
    end
    add_index :infrastructures, :sport_id
  end
end
