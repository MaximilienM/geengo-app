require "spec_helper"

describe "Firms routes" do

  it do
    get("/firms/1.css").should route_to(:controller => "firms", :action => "show", :id => "1", :format => "css")
  end

end