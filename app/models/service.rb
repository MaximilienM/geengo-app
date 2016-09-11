class Service < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :purchasable, :polymorphic => true

  has_many :sub_services, :dependent => :destroy, :inverse_of => :service

  # Validations
  #############

  validates :name, :presence => true
  validates :purchasable, :presence => true

  # Callbacks
  ###########
  
  before_save :set_purchasable_type_and_id

  # Instance methods
  ##################

  accepts_nested_attributes_for :sub_services, :reject_if => proc {|attribs| attribs[:name].blank? and attribs[:price].blank? and attribs[:discount].blank? and attribs[:eligible_conditions].blank?}
  
  # Protected methods
  ###################
  
  protected
  
  def set_purchasable_type_and_id
    self.purchasable_type_and_id = "#{purchasable.class.table_name}_#{purchasable.id}"
  end
end
