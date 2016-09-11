# TODO : mettre à jour le diagramme de classe

class Domain < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :firm

  # Validations
  #############

  validates :name, :presence => true, :uniqueness => true, :format => { :with => /^[\w-]+\.\w\w+$/, :allow_blank => true }

  # Callbacks
  ###########

  before_destroy :cancel_destroy_if_last_domain
  before_destroy :cancel_destroy_if_employees_use_the_domain

  # Private methods
  #################

  private

  def cancel_destroy_if_last_domain
    if firm && firm.domains.all.size == 1
      errors.add(:base, "last domain for firm")
      return false
    end
  end

  def cancel_destroy_if_employees_use_the_domain
    if firm && firm.employees.any? {|e| e.email =~ /@#{name}$/}
      errors.add(:base, "employees attached to the firm use this domain in their email")
      return false
    end
  end

end
