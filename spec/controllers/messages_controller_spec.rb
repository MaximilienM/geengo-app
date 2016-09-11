require 'spec_helper'

describe MessagesController do

  include_context "signed in front"

  describe "#create" do

    let(:params) { {:message => message_params} }
    let(:message_params) { Factory.attributes_for(:message) }
    before { @request.env["HTTP_REFERER"] = "/referrer-url" }

    it do
      post :create, params
      should redirect_to("/referrer-url")
    end

    context "with parent_id specified" do

      let(:parent) { Factory(:message, :content => "I am the parent") }
      let(:message_params) { {:sport_community_id => "1", :content => "I am the reply", :parent_id => parent.id} }

      it "should touch the parent" do
        post :create, params
        parent.reload
        parent.updated_at.should be > parent.created_at
      end

    end

  end

end
