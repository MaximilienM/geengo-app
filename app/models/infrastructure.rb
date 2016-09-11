# TODO : implement properties

class Infrastructure < ActiveRecord::Base

  # Module that handles services association and attributes
  include Purchasable

  # Associations
  ##############

  belongs_to :sport

  # TODO : This should go in GolfInfrastructure
  has_many :courses, :class_name => "GolfCourse", :foreign_key => "infrastructure_id", :inverse_of => :infrastructure, :dependent => :destroy

  has_many :comments, :class_name => "Message", :as => :commentable, :dependent => :destroy

  # Validations
  #############

  validates :sport_id, :presence => true
  validates :name, :presence => true, :uniqueness => true
  validates :display_name, :presence => true
  validates :hq_email, :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true}
  validates :contact_email, :format => {:with => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i, :allow_blank => true}
  validates :venue_zip_code, :hq_zip_code, :format => {:with => /^\d{5}$/, :allow_nil => true}

  validates :rib_bank, :format => {:with => /^\d{5}$/, :allow_blank => true}
  validates :rib_office, :format => {:with => /^\d{5}$/, :allow_blank => true}
  validates :rib_account, :format => {:with => /^\d{11}$/, :allow_blank => true}
  validates :rib_key, :format => {:with => /^\d{2}$/, :allow_blank => true}

  validates :iban, :format => {:with => /^[a-zA-Z0-9]{27}$/, :allow_blank => true}
  validates :bic, :format => {:with => /^[a-zA-Z]{8}[a-zA-Z]?[a-zA-Z]?[a-zA-Z]?$/, :allow_blank => true}

  validates :hq_phone, :hq_mobile, :hq_fax, :contact_phone, :format => {:with => /^\d{10}$/, :allow_blank => true}, :numericality => {:allow_blank => true}

  # Callbacks
  ###########

  before_save :set_type
  after_validation :geocode, :if => :full_hq_address_changed?

  extend ImportUploaders

  # Geocoder
  ##########

  geocoded_by :full_hq_address
  acts_as_gmappable :process_geocoding => false

  # Instance methods
  ##################

  mount_uploader :logo, InfrastructureLogoUploader
  mount_uploader :picture_1, InfrastructurePictureUploader
  mount_uploader :picture_2, InfrastructurePictureUploader
  mount_uploader :picture_3, InfrastructurePictureUploader

  # Attributes accessible for mass assignment
  attr_accessible(
    :sport_name,
    :kind,
    :name,
    :display_name,
    :description,
    :hq_address,
    :hq_zip_code,
    :hq_city,
    :hq_country,
    :hq_phone,
    :hq_mobile,
    :hq_fax,
    :hq_email,
    :hq_url,
    :contact_name,
    :contact_role,
    :contact_phone,
    :contact_email,
    :rib,
    :iban,
    :bic,
    :venue_name,
    :venue_address,
    :venue_zip_code,
    :venue_city,
    :venue_country,
    :practical_informations,
    :opening_hours,
    :equipments,
    :other_comments,
    :geengo_comments,

    # TODO : This should go in GolfInfrastructure
    :courses_attributes
  )

  # TODO : This should go in GolfInfrastructure
  accepts_nested_attributes_for :courses, :reject_if => Proc.new { |attribs| attribs.symbolize_keys[:name].blank? }

  # setter used when importing
  # finds the sport with the given name and then sets the sport_id attribute on the infrastructure
  def sport_name=(name)
    sport = Sport.find_by_name(name)
    self.sport_id = sport.try(:id)
  end

  # takes a full rib string like "00000 11111 123456798 12"
  # splits it with a space character and sets the rib_bank, rib_office, rib_account and rib_key attributes
  #
  # do nothing if full_rib is blank
  def rib=(full_rib)
    return if full_rib.blank?
    self.rib_bank, self.rib_office, self.rib_account, self.rib_key = full_rib.split(' ')
  end

  # Concatenates the hq address parts
  # Used to geocode the infra
  def full_hq_address
    part_1 = hq_address
    part_2 = [hq_zip_code, hq_city].reject(&:blank?).join(' ')
    part_3 = hq_country.present? ? hq_country : "France"
    [part_1, part_2, part_3].reject(&:blank?).join(', ')
  end

  # Used by geocoder for distance calculations
  def to_coordinates
    [latitude, longitude]
  end

  # Protected methods
  ###################

  protected

  # Sets the type attributes used for STI
  # Uses the sport name to build the type :
  #
  # ie : if sport is Golf, then type will be GolfInfrastructure
  def set_type
    new_type = [sport.name, "Infrastructure"].join('')

    begin
      new_type.constantize
      self.type = new_type
    rescue NameError
      self.type = nil
    end

  end

  # full_hq_address is a virtual attribute so no dirty info is set on it
  # this method checks all the attributes that compose the full_hq_address
  # and returns true if any of them has changed?
  def full_hq_address_changed?
    hq_address_changed? || hq_zip_code_changed? || hq_city_changed? || hq_country_changed?
  end

end