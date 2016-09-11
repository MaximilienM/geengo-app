require 'spec_helper'

describe InfrastructuresController do

  include_context "signed in front"

  describe "#index" do

    context "when :sport_name is a valid community for the current_firm" do
      let(:sport) { Factory(:sport, :name => "Football") }
      let(:sport_community) { Factory(:sport_community, :sport => sport, :firm => employee.firm) }

      context "with one infra for :sport_name and another one" do
        before do
          @infra_to_assign = Factory(:infrastructure, :sport => sport)
          @infra_to_ignore = Factory(:infrastructure)
        end

        it "assigns @infrastructures corresponding with :sport_name" do
          get :index, :sport_name => sport_community.name.downcase
          assigns(:infrastructures).should include(@infra_to_assign)
        end

        it "ignores infrastructures for other sports" do
          get :index, :sport_name => sport_community.name.downcase
          assigns(:infrastructures).should_not include(@infra_to_ignore)
        end

      end

      context "with 3 infras in Paris" do
        before do
          @st_laz       = Factory(:infrastructure, :sport => sport, :hq_city => "Paris", :hq_address => "Gare st lazare")
          @montparnasse = Factory(:infrastructure, :sport => sport, :hq_city => "Paris", :hq_address => "Montparnasse")
          @nation       = Factory(:infrastructure, :sport => sport, :hq_city => "Paris", :hq_address => "Nation")

          employee.firm.update_attribute(:address, "10 rue de londres, Paris") # near st laz
          employee.update_attributes(:address => "Bd de picpus", :city => "Paris") # near nation
        end

        context "when no search param is specified" do

          it "assigns the infras ordered by distance from the office" do
            get :index, :sport_name => sport_community.name.downcase
            assigns(:infrastructures).should == [@st_laz, @montparnasse, @nation]
          end

        end

        context "when searching near the employee's office" do

          it "assigns the infras ordered by distance from the office" do
            get :index, :sport_name => sport_community.name.downcase, :near => "office"
            assigns(:infrastructures).should == [@st_laz, @montparnasse, @nation]
          end

        end

        context "when searching near the employee's home" do

          it "assigns the infras ordered by distance from the employee's home" do
            get :index, :sport_name => sport_community.name.downcase, :near => "home"
            assigns(:infrastructures).should == [@nation, @montparnasse, @st_laz]
          end

        end

        context "when searching near a custom address" do

          it "assigns the infras ordered by distance from this address" do
            get :index, :sport_name => sport_community.name.downcase, :near => "other", :custom_address => "rue de vaugirard, paris"
            assigns(:infrastructures).should == [@montparnasse, @st_laz, @nation]
          end

        end

      end

    end

  end


end