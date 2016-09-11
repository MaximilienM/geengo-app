require 'spec_helper'

describe SportCommunityMembershipsController do

  include_context "signed in front"

  let(:community) { Factory(:sport_community) }

  describe "#create" do

    let(:params) { {:sport_community_membership => membership_params} }
    let(:membership_params) { {:sport_community_id => community.id} }
    before { @request.env["HTTP_REFERER"] = "/referrer-url" }

    it do
      post :create, params
      should redirect_to("/referrer-url")
    end

  end

end
