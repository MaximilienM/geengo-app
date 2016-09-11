require "spec_helper"

describe "Application routes" do

  describe "GET /" do
    subject { get("/") }
    it { should route_to(:controller => "profiles", :action => "show") }
  end

end