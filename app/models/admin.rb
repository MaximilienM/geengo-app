# TODO : RA edit should allow only 2 roles
# TODO : flash error sur /admins/sign_in

class Admin < User

  # Associations
  ##############
  
  belongs_to :infrastructure

  # Validations
  #############

  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :role_ids

  # Instance methods
  ##################

  attr_accessor :employees_import_id

end