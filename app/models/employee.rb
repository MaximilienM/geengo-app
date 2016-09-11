# TODO : ajouter lien vers sport commu membership edit depuis le show
# TODO : select de l'année pour le date of birth
# TODO : perte de la tranche qf lors du gain de role pour un employee
# TODO : changement du mot de passe d'un employée (loggué en tant que admin ce) fait tomber l'appli

class Employee < User

  # Associations
  ##############

  belongs_to :firm
  belongs_to :work_council_group

  has_many :sport_community_memberships, :dependent => :destroy
  has_many :sport_communities, :through => :sport_community_memberships, :after_remove => :destroy_orphan_documents
  has_many :documents, :through => :sport_community_memberships, :source => :administrative_documents
  has_many :messages, :dependent => :destroy

  has_many :communities_events, :through => :sport_communities, :source => :events

  # Validations
  #############

  validates :firm_id, :presence => :true
  validates :first_name, :presence => true, :if => :confirmed?
  validates :last_name, :presence => true, :if => :confirmed?
  validates :date_of_birth, :presence => true, :if => :confirmed?
  validates :mobile, :format => {:with => /^\d{10}$/, :allow_blank => true}
  validates :zip_code, :format => {:with => /^\d{5}$/, :allow_nil => true}
  validates :work_council_group_id,
    :inclusion => {:in => Proc.new {|e| e.firm.work_council_group_ids}},
    :if => Proc.new {|e| e.firm.present?},
    :allow_blank => true

  validate :email_domain_eq_firm_domain

  devise :registerable, :confirmable

  # Setup accessible (or protected) attributes for your model
  attr_accessible(
    :email,
    :password, :password_confirmation,
    :remember_me,
    :first_name, :last_name,
    :department, :work_council_group_name,
    :date_of_birth,
    :photo,
    :address,
    :zip_code,
    :city,
    :mobile,
    :sport_community_memberships_attributes,
    :skip_confirmation
  )

  # Callbacks
  ###########

  before_validation :set_firm_from_email
  before_validation :set_work_council_group_id_from_work_council_group_name

  after_initialize do
    return if persisted?
    @skip_confirmation = true if @skip_confirmation.nil?
  end

  # Instance methods
  ##################

  accepts_nested_attributes_for :sport_community_memberships,
    :reject_if => proc { |attrs| attrs["sport_community_id"] == "0" },
    :allow_destroy => true

  mount_uploader :photo, PhotoUploader

  attr_accessor :work_council_group_name

  def name
    [first_name, last_name].join(' ')
  end

  def domain_from_email
    email =~ /@(.+)$/
    Domain.find_by_name($1)
  end

  # returns true if the employee has completed his registration process (ie : first connection)
  # providing his first_name, last_name and date_of_birth
  def registered?
    [:first_name, :last_name, :date_of_birth].map do |attribute|
      self.send(attribute).present?
    end.inject(true) { |memo, element| memo && element }
  end

  def skip_confirmation=(value)
    @skip_confirmation = ActiveRecord::ConnectionAdapters::Column::TRUE_VALUES.include?(value)
  end

  # build all the sport_community_memberships that are available in the employee's firm
  # and are not present in the associations's target array
  def build_missing_sport_community_memberships
    firm_sc_ids = firm.sport_community_ids
    resource_sc_ids = sport_community_memberships.map(&:sport_community_id)
    missing_sport_community_ids = firm_sc_ids - resource_sc_ids

    missing_sport_community_ids.each do |sc_id|
      sport_community_memberships.build(:sport_community_id => sc_id)
    end

    sport_community_memberships.sort_by!(&:sport_community_id)
  end
  
  # Joins the address, zip_code and city, rejecting blank values
  def full_address
    part_1 = address
    part_2 = [zip_code, city].reject(&:blank?).join(' ')
    part_3 = "France"
    [part_1, part_2, part_3].reject(&:blank?).join(', ')
  end

  # Protected methods
  ###################

  protected

  def confirmation_required?
    !@skip_confirmation && super
  end

  # Private methods
  #################

  private

  # When a sport community membership is DELETED with the employee.sport_community_ids=() method
  # the destroy method is not called on it, hence creating orphan administrative_document
  #
  # This methods destroys those orphan administrative_documents
  def destroy_orphan_documents(sport_community)
    AdministrativeDocument.includes(:sport_community_membership).find_all {|scm| scm.sport_community_membership.nil? }.each(&:destroy)
  end

  def email_domain_eq_firm_domain
    return if email.blank? or firm.nil?
    domain_names = firm.domains.map(&:name)
    errors.add(:email, "domain does not match one of the firm domains #{domain_names.join(', ')}") unless email =~ /@#{domain_names.join('|')}$/
  end

  def set_firm_from_email
    return unless firm_id.nil?
    if domain_from_email.try(:firm)
      self.firm = domain_from_email.firm
    else
      errors.add(:email, I18n.t('activerecord.errors.models.employee.attributes.email.domain_does_not_belong_to_any_firm'))
    end
  end

  # Uses @work_council_group_name to set the @work_council_group
  # if work_council_group_id has not already been changed
  def set_work_council_group_id_from_work_council_group_name
    if @work_council_group_name.present? && !work_council_group_id_changed? && firm
      t = WorkCouncilGroup.arel_table
      t[:name].matches(@work_council_group_name)
      group = firm.work_council_groups.where(t[:name].matches(@work_council_group_name)).first

      if group
        self.work_council_group = group
      else
        errors.add(:work_council_group_name)
      end
    end
  end

end