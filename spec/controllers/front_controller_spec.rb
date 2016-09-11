require 'spec_helper'

describe FrontController do

  include_context "signed in front"

  describe "#current_community" do

    subject { @controller.send(:current_community) }

    context "when no :sport_name is passed in the params" do
      it { should be_nil }
    end

    context "when param :sport_name corresponds to a community for the firm" do
      let(:community) { Factory(:sport_community, :firm => employee.firm) }
      before { @controller.stub(:params).and_return(:sport_name => community.name.downcase) }
      it { should == community }
    end

  end

  describe "#get_in_sliders_events" do

    context "with 2 published events for the firm, one featured, the other not" do
      before do
        community = Factory(:sport_community, :firm => employee.firm)
        @featured = Factory(:published_featured_event, :sport_id => community.sport_id)

        scm = Factory(:sport_community_membership, :employee => employee)
        @non_featured = Factory(:published_event, :sport_id => scm.sport_community.sport_id)

        subject.get_in_sliders_events
      end

      it "should assign featured events to @featured_slider_events" do
        assigns(:featured_slider_events).should == [@featured]
      end

      it "should assign normal events to @left_slider_events" do
        assigns(:my_communities_slider_events).should == [@non_featured]
      end

    end

  end

end