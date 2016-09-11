# encoding: utf-8

class Event < ActiveRecord::Base

  # Module that handles services association and attributes
  include Purchasable

  # Associations
  ##############

  belongs_to :sport

  has_many :comments, :class_name => "Message", :as => :commentable, :dependent => :destroy

  # Validations
  #############

  validates :name, :presence => true
  validates :sport_id, :presence => true
  validates :starts_at, :presence => true
  validates :ends_at, :presence => true

  validate :ends_at_greater_than_starts_at

  # Validate :registration_ends_on and :broadcast_ends_on are greater than or equal to their
  # starts_on counterparts
  [:registration, :broadcast].each do |sym|
    validate do
      start_attribute = "#{sym}_starts_on"
      end_attribute = "#{sym}_ends_on"

      return unless (self.send(end_attribute) && self.send(start_attribute))

      message = I18n.t('errors.messages.greater_than_or_equal_to', :count => self.class.human_attribute_name(start_attribute))
      errors.add(end_attribute, message) unless self.send(end_attribute) >= self.send(start_attribute)
    end
  end

  validates :registration_email, :organizer_email, :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true}

  validates :max_players_count, :max_team_players_count, :numericality => {:allow_nil => true}
  validates :venue_zip_code, :arrival_zip_code, :organizer_zip_code, :format => {:with => /^\d{5}$/, :allow_blank => true}

  validates :venue_phone, :organizer_phone, :format => {:with => /^\d{10}$/, :allow_blank => true}

  # Callbacks
  ###########

  after_validation :geocode, :if => :full_venue_address_changed?

  extend ImportUploaders

  # Geocoder
  ##########

  geocoded_by :full_venue_address
  acts_as_gmappable :process_geocoding => false

  # Scopes
  ########

  scope :featured, where(:featured => true)
  scope :non_featured, where(arel_table[:featured].eq(nil).or(arel_table[:featured].eq(false)))
  scope :published, Proc.new {
    where(
      arel_table[:broadcast_starts_on].lteq(Date.today),
      arel_table[:broadcast_ends_on].gteq(Date.today)
    )
  }
  scope :in_sliders, Proc.new {
    published.order(arel_table[:pfs_registration_ends_on].desc).limit(5)
  }

  # Instance methods
  ##################

  mount_uploader :brochure_image, EventBrochureUploader

  attr_accessible(
    :sport_name,
    :name,
    :starts_at,
    :ends_at,
    :description,
    :short_description,
    :target,
    :nature,
    :kind,
    :game_kind,
    :player_category,
    :participation_terms,
    :max_players_count,
    :max_team_players_count,
    :venue_name,
    :venue_phone,
    :venue_address,
    :venue_zip_code,
    :venue_city,
    :venue_country,
    :travel_informations,
    :arrival_address,
    :arrival_zip_code,
    :arrival_city,
    :arrival_country,
    :scale,
    :website_url,
    :registration_strategy,
    :payment_terms,
    :registration_starts_on,
    :registration_ends_on,
    :registration_email,
    :registration_mail,
    :practical_informations,
    :organizer_name,
    :organizer_contact,
    :organizer_phone,
    :organizer_email,
    :organizer_address,
    :organizer_zip_code,
    :organizer_city,
    :organizer_rib,
    :broadcast_starts_on,
    :broadcast_ends_on,
    :featured,
    :pfs_registration_ends_on
  )

  # Duration of the event
  # equals ends_at - starts_at
  def duration
    ends_at - starts_at
  end

  # setter used when importing
  # finds the sport with the given name and then sets the sport_id attribute on the infrastructure
  def sport_name=(name)
    sport = Sport.find_by_name(name)
    self.sport_id = sport.try(:id)
  end

  def full_venue_address
    part_1 = venue_address
    part_2 = [venue_zip_code, venue_city].reject(&:blank?).join(' ')
    part_3 = "France"
    [part_1, part_2, part_3].reject(&:blank?).join(', ')
  end

  protected

  def full_venue_address_changed?
    venue_address_changed? || venue_zip_code_changed? || venue_city_changed?
  end

  private

  def ends_at_greater_than_starts_at
    return unless (ends_at && starts_at)
    errors.add(:ends_at, "doit être supérieure à la date de début") unless ends_at > starts_at
  end

end