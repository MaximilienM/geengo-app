class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :category
      t.belongs_to :sport
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.text :description
      t.text :short_description
      t.string :target
      t.string :nature
      t.string :kind
      t.string :game_kind
      t.string :player_category
      t.text :participation_terms
      t.integer :max_players_count
      t.integer :max_team_players_count
      t.string :venue_name
      t.string :venue_phone
      t.string :venue_address
      t.string :venue_zip_code
      t.string :venue_city
      t.string :venue_country
      t.text :travel_informations
      t.string :arrival_address
      t.string :arrival_zip_code
      t.string :arrival_city
      t.string :arrival_country
      t.string :scale
      t.string :website_url
      t.string :brochure_image
      t.string :registration_strategy
      t.text :payment_terms
      t.date :registration_starts_on
      t.date :registration_ends_on
      t.string :registration_email
      t.text :registration_mail
      t.text :practical_informations
      t.string :organizer_name
      t.string :organizer_contact
      t.string :organizer_phone
      t.string :organizer_email
      t.string :organizer_address
      t.string :organizer_zip_code
      t.string :organizer_city
      t.string :organizer_rib
      t.date :broadcast_starts_on
      t.date :broadcast_ends_on
      t.boolean :featured

      t.timestamps
    end
    add_index :events, :sport_id
  end
end
