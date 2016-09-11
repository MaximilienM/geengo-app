class SportCommunity < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :firm
  belongs_to :sport

  has_many :memberships, :class_name => "SportCommunityMembership", :dependent => :destroy
  has_many :members, :through => :memberships, :source => :employee
  has_many :messages, :dependent => :destroy

  has_many :events, :through => :sport

  # Validations
  #############

  validates :firm_id, :presence => true
  validates :sport_id, :presence => true

  # Scopes
  ########

  scope :ordered_by_sport_name, joins(:sport).order("sports.name")

  # Instance methods
  ##################

  def name
    sport.name
  end

end
