class Message < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :sport_community
  belongs_to :employee
  belongs_to :commentable, :polymorphic => true

  # Validations
  #############

  validates :sport_community_id, :presence => true
  validates :employee_id, :presence => true
  validates :content, :presence => true

  has_ancestry

end