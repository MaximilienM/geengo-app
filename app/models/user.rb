# TODO : sign out kills all sessions

class User < ActiveRecord::Base

  # Associations
  ##############

  has_and_belongs_to_many :roles

  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Instance methods
  ##################

  attr_accessor :import_id
  attr_accessor :employee

  def has_role?(role_sym)
    roles.any? { |r| r.name.underscore.to_sym == role_sym }
  end

end