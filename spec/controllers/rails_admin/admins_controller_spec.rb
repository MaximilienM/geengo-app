require 'spec_helper'

describe RailsAdmin::AdminsController do

  describe "#update" do
    subject { put :update, :id => admin.id, :model_name => "admins" }

    context "when admin is not able to read User" do
      let(:admin) {Factory(:infrastructure_admin)}

      it "should redirect to the rails_admin path" do
        sign_in(admin)
        subject.should redirect_to "/admin/"
      end

    end

  end

end
