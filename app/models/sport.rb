class Sport < ActiveRecord::Base

  # Associations
  ##############

  has_many :infrastructures, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :sport_communities, :dependent => :destroy
  has_many :firms, :through => :sport_communities

  # Validations
  #############

  validates :name, :presence => true, :uniqueness => true

end