require "spec_helper"

describe "Messages routes" do

  it do
    post("/messages").should route_to(:controller => "messages", :action => "create")
  end

end