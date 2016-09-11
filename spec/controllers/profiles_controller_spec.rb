require 'spec_helper'

describe ProfilesController do

  include_context "signed in front"

  describe "#show" do

    context "context" do

      before do
        sc1 = Factory(:sport_community)
        sc2 = Factory(:sport_community)
        scm1 = Factory(:sport_community_membership, :employee => employee, :sport_community => sc1)
        scm2 = Factory(:sport_community_membership, :employee => employee, :sport_community => sc2)
        @m1 = Factory(:message, :sport_community => sc1)
        @m2 = Factory(:message, :sport_community => sc2)
      end

      it "assigns @messages with threads for all the employee's memberships" do
        get :show
        assigns(:messages).keys.should include(@m1, @m2)
      end

      it "orders root messages by created_at desc" do
        get :show
        assigns(:messages).keys.should == assigns(:messages).keys.sort_by(&:created_at).reverse
      end

      it "replies should be ordered by created_at" do
        last_rep = Factory(:message, :parent => @m1, :created_at => Time.now + 1.hour)
        first_rep = Factory(:message, :parent => @m1, :created_at => Time.now - 1.hour)
        get :show
        assigns(:messages)[@m1].keys.should == assigns(:messages)[@m1].keys.sort_by(&:created_at)
      end

    end

  end

end