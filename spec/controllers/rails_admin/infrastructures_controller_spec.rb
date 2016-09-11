require 'spec_helper'

describe RailsAdmin::InfrastructuresController do

  before {sign_in(user)}

  describe "#edit" do
    let(:user) {Factory(:geengo_admin)}
    let(:infrastructure) { Factory(:infrastructure)}

    context "when model is an STI class" do
      let(:golf) { Factory(:sport, :name => "Golf")}
      let(:infrastructure) { Factory(:infrastructure, :sport => golf)}

      it "should cat @object to an Infrastructure" do
        get :edit, :model_name => "infrastructures", :id => infrastructure.id
        assigns(:object).class.should == Infrastructure
      end

    end

  end
end