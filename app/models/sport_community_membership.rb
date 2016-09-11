class SportCommunityMembership < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :employee
  belongs_to :sport_community

  has_many :administrative_documents, :dependent => :destroy
  # has_many :messages

  # Validations
  #############

  validates :employee_id, :presence => true
  validates :sport_community_id, :presence => true

  # Callbacks
  ###########

  before_validation :set_name

  # Scopes
  ########
  
  scope :ordered_by_sport_name, joins(:sport_community => :sport).order("sports.name")

  # Instance methods
  ##################

  accepts_nested_attributes_for :administrative_documents,
    :reject_if => proc { |attributes| attributes[:document].blank? },
    :allow_destroy => true

  def tranlsated_level
    return unless level.present?
    I18n.t("activerecord.sport_community_membership.level.#{level}")
  end

  def name_for_employee
    "#{sport_community.name} (#{tranlsated_level})"
  end

  def sport_name_and_level
    [sport_community.name, tranlsated_level].join(' - ')
  end

  # Protected methods
  ###################

  protected

  def set_name
    self.name = "#{employee.try(:name)} - #{sport_community.try(:name)} (#{tranlsated_level})"
  end

end