class RailsAdmin::AdminsController < RailsAdmin::MainController

  def redirect_to_on_success
    notice = t("admin.flash.successful", :name => @model_config.label, :action => t("admin.actions.#{params[:action]}d"))
    if cannot?(:read, Admin) && !params[:_add_edit]
      redirect_to dashboard_path, :notice => notice
    else
      super
    end
  end

end
