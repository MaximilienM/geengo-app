require 'spec_helper'

describe MembersController do

  include_context "signed in front"

  let(:sc) { Factory(:sport_community, :firm => employee.firm)}

  describe "#index" do

    context "with one employee attached to the sport_community" do

      before do
        Factory(:sport_community_membership, :employee => employee, :sport_community => sc)
      end

      it "should assign @members with this employee" do
        get :index, :sport_name => sc.name.downcase
        assigns(:members).should include(employee)
      end

    end

    context "with no employees attached to the sport_community" do

      it "assign @members should be empty" do
        get :index, :sport_name => sc.name.downcase
        assigns(:members).should be_empty
      end


    end


  end

end
