require "spec_helper"

describe "Events routes" do

  it do
    get("/events").should route_to(:controller => "events", :action => "index")
  end

  it do
    get("/football/events").should route_to(:controller => "events", :action => "index", :sport_name => "football")
  end

  it do
    get("/football/events/1").should route_to(:controller => "events", :action => "show", :sport_name => "football", :id => "1")
  end

end