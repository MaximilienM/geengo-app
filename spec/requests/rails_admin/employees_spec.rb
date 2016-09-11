# encoding : utf-8

require 'spec_helper'

describe "RailsAdmin for Employees" do

  include_context "admin is a geengo_admin"
  before { login_as(admin) }

  describe "Create a new employee" do
    before do
      @d = Factory(:domain_with_firm)
      visit "/admin/employee/new"
    end

    it "should work with all valid fields" do
      fill_in I18n.t("activerecord.attributes.employee.first_name"), :with => "Julien"
      fill_in I18n.t("activerecord.attributes.employee.last_name"), :with => "Palmas"
      fill_in "Email", :with => "julien.palmas@#{@d.name}"
      fill_in "Password", :with => "sdfsdf"
      fill_in "Password confirmation", :with => "sdfsdf"
      click_button I18n.t("admin.new.save")

      within("div.flash .notice") do
        page.should have_content("succès")
      end
    end
  end

end