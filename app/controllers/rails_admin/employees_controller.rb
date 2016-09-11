class RailsAdmin::EmployeesController < RailsAdmin::MainController

  def edit
    user = _current_user
    user.employee = @object
    @current_ability = Ability.new(user)
    super
  end

  def bulk_action
    redirect_to list_path, :notice => t("admin.flash.noaction") and return if params[:bulk_ids].blank?

    case params[:bulk_action]
    when "delete" then bulk_delete
    when "export" then export
    when "ask_confirmation" then ask_confirmation
    else redirect_to(list_path(:model_name => @abstract_model.to_param), :notice => t("admin.flash.noaction"))
    end
  end

  protected

    def ask_confirmation
      @authorization_adapter.authorize(:ask_confirmation, @abstract_model) if @authorization_adapter

      @bulk_objects, @current_page, @page_count, @record_count = list_entries

      @bulk_objects.each do |employee|
        employee.send_confirmation_instructions unless employee.confirmed?
      end

      redirect_to(list_path(:model_name => @abstract_model.to_param), :notice => t("admin.employees.list.confirmations_sent"))
    end

end