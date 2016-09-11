require 'spec_helper'

describe SportCommunitiesController do

  include_context "signed in front"

  describe "#show" do

    context "when a sport community exists for the given :sport_name" do
      let(:sc) { Factory(:sport_community, :firm => employee.firm) }
      let(:params) { {:sport_name => sc.name} }

      context "with 2 published and featured events, but just one for the community" do
        before do
          @for_community = Factory(:published_featured_event, :sport => sc.sport)
          Factory(:published_featured_event)
        end

        it "should assign @featured_slider_events with the community event" do
          get :show, params
          assigns(:featured_slider_events).should == [@for_community]
        end
      end

      context "with 2 published events, but just one for the community" do
        before do
          Factory(:sport_community_membership, :employee => employee, :sport_community => sc)
          @for_community = Factory(:published_event, :sport => sc.sport)
          Factory(:published_event)
        end

        it "should assign @my_communities_slider_events with the community event" do
          get :show, params
          assigns(:my_communities_slider_events).should == [@for_community]
        end
      end

      context "when the community has 2 messages" do
        before do
          2.times { Factory(:message, :sport_community => sc) }
        end

        it "should assign a hash to @messages with its roots ordered_by created_at desc" do
          get :show, params
          root_messages = assigns(:messages).keys
          root_messages.first.created_at.should be > root_messages.last.created_at
        end
      end

      context "with one member" do

        before do
          Factory(:sport_community_membership, :employee => employee, :sport_community => sc)
        end

        it "should assign @members with the member" do
          get :show, params
          assigns(:members).should include(employee)
        end

      end

      context "with 10 members" do

        before do
          @old_members = []
          @recent_members = []
          5.times {@recent_members << Factory(:sport_community_membership, :sport_community => sc).employee}
          5.times do
            scm = Factory(:sport_community_membership, :sport_community => sc)
            scm.update_attribute(:created_at, Time.now - 1.day)
            @old_members << scm.employee
          end
        end

        it "should only assign 5 @members" do
          get :show, params
          assigns(:members).should have(5).items
        end

        it "should display the most recent members (based on sport_community_membership.created_at)" do
          get :show, params
          assigns(:members).should include(*@recent_members)
        end

        it "should_not display old members (based on sport_community_membership.created_at)" do
          get :show, params
          assigns(:members).should_not include(*@old_members)
        end

      end

    end

    context "when NO sport community exists for the given :sport_name" do
      let(:sport) { Factory(:sport, :name => "I have no sport community attached to me")}
      let(:params) { {:sport_name => sport.name} }
      it "should respond with a 404 status" do
        get :show, params
        assert_response 404
      end
    end

  end

end