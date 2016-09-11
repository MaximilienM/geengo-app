require "spec_helper"

describe "Sport communities routes" do

  it do
    get("/tennis/community").should route_to(:controller => "sport_communities", :action => "show", :sport_name => "tennis")
  end

end