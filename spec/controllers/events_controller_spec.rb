require 'spec_helper'

describe EventsController do

  include_context "signed in front"

  describe "#index" do

    let(:sport) { Factory(:sport, :name => "Football") }

    context "when :sport_name is a valid community for the current_firm" do
      let(:sport_community) { Factory(:sport_community, :sport => sport, :firm => employee.firm) }

      context "with one event for :sport_name and another one" do
        before do
          @event_to_assign = Factory(:published_event, :sport => sport)
          @event_to_ignore = Factory(:published_event)
        end

        it "assigns @events corresponding with :sport_name" do
          get :index, :sport_name => sport_community.name.downcase
          assigns(:events).should include(@event_to_assign)
        end

        it "ignores events for other sports" do
          get :index, :sport_name => sport_community.name.downcase
          assigns(:events).should_not include(@event_to_ignore)
        end

      end

    end

  end


end