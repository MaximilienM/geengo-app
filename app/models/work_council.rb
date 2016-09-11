class WorkCouncil < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :firm

  has_many :groups, :class_name => "WorkCouncilGroup", :dependent => :destroy

  # Validations
  #############

  validates :annual_discount_ceiling, :presence => true
  validates :firm_id, :presence => true, :uniqueness => true

  # Callbacks
  ###########

  before_save :set_name

  # Protected methods
  ###################

  protected

  def set_name
    self.name = firm.name
  end

end