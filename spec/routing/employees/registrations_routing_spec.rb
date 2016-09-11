require "spec_helper"

describe "Employees::Registrations routes" do

  describe "GET /employees/sign_up" do
    subject { get("/employees/sign_up") }
    it { should route_to(:controller => "employees/registrations", :action => "new") }
  end

end