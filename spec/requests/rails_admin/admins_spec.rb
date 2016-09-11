require 'spec_helper'

describe "RailsAdmin for Admins" do

  include_context "admin is a geengo_admin"
  before { login_as(admin) }

  describe "Edit" do
    before { visit "/admin/admins/#{admin.id}/edit"}
    it "should have the role ids select" do
      page.should have_css('.admin_role_ids')
    end
  end

end