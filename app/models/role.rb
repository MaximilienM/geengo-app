class Role < ActiveRecord::Base

  # validations
  #############

  validates :name, :presence => true, :uniqueness => true

  # Instance methods
  ##################

  def human_name
    I18n.t "activerecord.role.name.#{name}"
  end

end