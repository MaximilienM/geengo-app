class Employees::RegistrationsController < Devise::RegistrationsController

  # before_filter :redirect_if_registered, :only => [:edit, :update]

  def activation_pending
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    activation_pending_path
  end

  def redirect_if_registered
    redirect_to profile_path if current_employee.registered?
  end

end