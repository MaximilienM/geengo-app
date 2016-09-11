require "spec_helper"

describe "routes for RailsAdmin" do

  describe "GET /admin/employees/1/edit" do
    subject { get("/admin/employees/1/edit") }
    it { should route_to(:controller => "rails_admin/employees", :action => "edit", :id => "1", :model_name => "employees") }
  end

  describe "PUT /admin/admins/1" do
    subject { put("/admin/admins/1") }
    it { should route_to(:controller => "rails_admin/admins", :action => "update", :id => "1", :model_name => "admins") }
  end

  %w(employees_imports infrastructures_imports events_imports).each do |model_name|
    describe "POST /admin/#{model_name}" do
      subject { post("/admin/#{model_name}") }
      it { should route_to(:controller => "rails_admin/imports", :action => "create", :model_name => model_name) }
    end
  end

  describe "GET /admin/imports/1/discards" do
    subject { get("/admin/imports/1/discards") }
    it { should route_to(:controller => "rails_admin/import_discards", :action => "list", :model_name => "import_discards", :import_id => "1") }
  end

  describe "GET /admin/user/1/edit" do
    subject { get('/admin/user/1/edit') }
    it { should route_to(:controller => "rails_admin/users", :action => "edit", :model_name => "user", :id => "1") }
  end

  describe "PUT /admin/users/1" do
    subject { put('/admin/users/1') }
    it { should route_to(:controller => "rails_admin/users", :action => "update", :model_name => "users", :id => "1")}
  end

  describe "GET /admin/infrastructures/1/edit" do
    subject { get('/admin/infrastructures/1/edit') }
    it { should route_to(:controller => "rails_admin/infrastructures", :action => "edit", :model_name => "infrastructures", :id => "1") }
  end

  describe "PUT /admin/infrastructures/1" do
    subject { put('/admin/infrastructures/1') }
    it { should route_to(:controller => "rails_admin/infrastructures", :action => "update", :model_name => "infrastructures", :id => "1") }
  end

end