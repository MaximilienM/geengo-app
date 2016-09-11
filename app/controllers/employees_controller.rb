class EmployeesController < ApplicationController

  def valid_email
    respond_to do |format|
      format.js {
        @employee = Employee.find_by_email(params[:id])
      }
    end
  end

end