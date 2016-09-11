class GolfCourse < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :infrastructure

  # Validations
  #############

  validates :infrastructure, :presence => true
  validates :name, :presence => true
  validates :length, :numericality => {:greater_than_or_equal_to => 0}

end
