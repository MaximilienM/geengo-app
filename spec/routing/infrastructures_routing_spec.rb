require "spec_helper"

describe "Infrastructures routes" do

  it do
    get("/football/infrastructures").should route_to(:controller => "infrastructures", :action => "index", :sport_name => "football")
  end

  it do
    get("/football/infrastructures/1").should route_to(:controller => "infrastructures", :action => "show", :sport_name => "football", :id => "1")
  end

end