class RailsAdmin::UsersController < RailsAdmin::MainController

  # Override get_attributes defined in RailsAdmin::MainController
  # to set the :user with the corresponding key (:emplyoyee or :admin)
  # depending on the current_user class
  def get_attributes
    params[:user] = params[:employee] || params[:admin]
    super
  end

  def redirect_to_on_success
    # make sure we are not logged out because of password change
    sign_in(@object, :bypass => true)

    notice = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.#{params[:action]}d"))

    redirect_to dashboard_path, :notice => notice
  end

end
