# encoding : utf-8

class WorkCouncilGroup < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :work_council

  has_one :firm, :through => :work_council

  has_many :employees

  # Validations
  #############

  validates :work_council_id, :presence => true, :if => Proc.new {|wcg| wcg.firm.blank?}
  validates :name, :presence => true, :uniqueness => {:scope => :work_council_id, :case_sensitive => false}
  validates :discount_percentage, :presence => true, :numericality => {:greater_than_or_equal_to => 0, :less_than_or_equal_to => 100}
  validates :annual_discount_ceiling, :presence => true, :numericality => {:greater_than_or_equal_to => 0}
  validates :transaction_discount_ceiling, :presence => true,:numericality => {:greater_than_or_equal_to => 0}

  validate :presence_of_firm

  # Private methods
  #################

  private

  # This validation adds an error on :firm_id (used by rails_admin on the has_one field)
  # when the firm object is not set and the work_council_id is not set as well
  def presence_of_firm
    errors.add(:firm_id, I18n.t("errors.messages.blank")) if firm.blank? && work_council_id.blank?
  end

end