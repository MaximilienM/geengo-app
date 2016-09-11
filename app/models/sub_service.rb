class SubService < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :service

  # Validations
  #############

  validates :name, :presence => true, :uniqueness => {:scope => :service_id}
  validates :service, :presence => true
  validates :price, :numericality => {greater_than_or_equal_to: 0}
  validates :discount, :numericality => {greater_than_or_equal_to: 0, less_than_or_equal_to: proc {|ss| ss.price}}

  # Callbacks
  ###########

  # Make sure price and discount are set to 0 before validation in case they are blank
  before_validation do
    self.price = 0 if price.blank?
    self.discount = 0 if discount.blank?
  end

end