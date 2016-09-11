require "spec_helper"

describe "Sport communities memberships routes" do

  it do
    post("/sport_community_memberships").should route_to(:controller => "sport_community_memberships", :action => "create")
  end

  it do
    put("/sport_community_memberships/1").should route_to(:controller => "sport_community_memberships", :action => "update", :id => "1")
  end


end