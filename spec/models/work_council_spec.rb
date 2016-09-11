require 'spec_helper'

describe WorkCouncil do

  let(:wc) { Factory.build(:work_council) }
  subject { wc }

  describe "its annual_discount_ceiling" do
    it "should be present" do
      Factory.build(:work_council, :annual_discount_ceiling => nil).should have(1).error_on(:annual_discount_ceiling)
    end
  end

  describe "its firm_id" do
    it "should be present" do
      Factory.build(:work_council, :firm_id => nil).should have(1).error_on(:firm_id)
    end

    it "should be unique" do
      a = Factory(:work_council)
      b = Factory.build(:work_council)
      b.firm_id = a.firm_id
      b.should have(1).error_on(:firm_id)
    end
  end

  it "should destroy its groups on destroy" do
    g = Factory(:work_council_group)
    g.work_council.destroy
    expect {g.reload}.to raise_error(ActiveRecord::RecordNotFound)
  end

  context "when new" do
    its(:annual_discount_ceiling) {should be_zero}
  end

  describe "#save" do
    before { wc.save }
    its(:name) { should == wc.firm.name }
  end

end