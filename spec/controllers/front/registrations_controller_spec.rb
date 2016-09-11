require 'spec_helper'

describe Employees::RegistrationsController do

  let(:available_domain) { Factory(:domain_with_firm) }

  before do
    setup_controller_for_warden
    request.env["devise.mapping"] = Devise.mappings[:employee]
  end

  describe "#create" do
    subject { post :create, :employee => {:email => "john.doe@#{available_domain.name}", :password => "sdfsdf", :skip_confirmation => false} }
    it { should redirect_to(activation_pending_path) }
  end

  describe "#update"

end
