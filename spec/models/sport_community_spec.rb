require 'spec_helper'

describe SportCommunity do

  let(:sport_community) { Factory(:sport_community) }
  subject { sport_community }

  it "should validate presence of sport" do
    Factory.build(:sport_community, :sport_id => nil).should have(1).error_on(:sport_id)
  end

  it "should validate presence of firm" do
    Factory.build(:sport_community, :firm_id => nil).should have(1).error_on(:firm_id)
  end

  it "should destroy its memberships after destroy" do
    sc = Factory(:sport_community)
    scm = sc.memberships.create :employee => Factory(:employee)
    sc.destroy
    expect {scm.reload}.to raise_error(ActiveRecord::RecordNotFound)
  end

  describe "#name" do
    it "should be its sport's name" do
      sc = Factory.build(:sport_community)
      sport = sc.sport
      sc.name.should eq(sport.name)
    end
  end

  [:message].each do |sym|
    context "with one #{sym}" do
      before { @to_destroy = Factory(sym, :sport_community => sport_community) }
      include_examples "destroy associations"
    end
  end


end