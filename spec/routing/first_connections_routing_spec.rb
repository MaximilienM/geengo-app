require "spec_helper"

describe "First connections routes" do

  it do
    get("/first_connection").should route_to(:controller => "first_connections", :action => "edit")
  end

  it do
    put("/first_connection").should route_to(:controller => "first_connections", :action => "update")
  end


end