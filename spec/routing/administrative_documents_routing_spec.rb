require "spec_helper"

describe "Sport communities routes" do

  it do
    put("/administrative_documents/1").should route_to(:controller => "administrative_documents", :action => "update", :id => "1")
  end

  it do
    delete("/administrative_documents/1").should route_to(:controller => "administrative_documents", :action => "destroy", :id => "1")
  end

end