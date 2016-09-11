require 'spec_helper'

describe Employees::ConfirmationsController do

  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:employee]
  end

  context "with an employee waiting confirmation" do
    before do
      employee = Factory.build(:employee)
      employee.stub(:confirmation_required?).and_return(false)
      employee.save
      Employee.stub(:confirm_by_token).and_return(employee)
    end

    describe "#show" do
      subject { get :show, :confirmation_token => "confirmation-token" }
      it { should redirect_to(first_connection_path) }
    end

  end

end
