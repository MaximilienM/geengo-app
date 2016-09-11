class FirstConnectionsController < ApplicationController

  layout false
  before_filter :authenticate_employee!

  def edit
  end

  def update
    current_employee.attributes = params[:employee]

    if current_employee.save
      sign_in(:employee, current_employee, :bypass => true)
      redirect_to "/"
    else
      flash[:alert] = "Merci de corriger les erreurs suivantes"
      render :edit
    end

  end

end
