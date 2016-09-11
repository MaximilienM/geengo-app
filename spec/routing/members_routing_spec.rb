require "spec_helper"

describe "Members routes" do

  it do
    get("/tennis/community/members").should route_to(:controller => "members", :action => "index", :sport_name => "tennis")
  end

  it do
    get("/tennis/events/1/members").should route_to(
      :controller => "members",
      :action => "index",
      :sport_name => "tennis",
      :parent_type => "events",
      :parent_id => "1"
    )
  end

end