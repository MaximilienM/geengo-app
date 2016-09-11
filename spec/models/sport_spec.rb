require 'spec_helper'

describe Sport do

  let(:sport) { Factory(:sport) }
  subject { sport }

  it "should validate presence of name" do
    Factory.build(:sport, :name => nil).should have(1).error_on(:name)
  end

  it "should validate uniqueness of name" do
    s1 = Factory(:sport, :name => "Tennis")
    Factory.build(:sport, :name => s1.name).should have(1).error_on(:name)
  end

  [:sport_community, :infrastructure, :event].each do |sym|
    context "with one #{sym}" do
      before { @to_destroy = Factory(sym, :sport => sport) }
      include_examples "destroy associations"
    end
  end

end