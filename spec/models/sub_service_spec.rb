require 'spec_helper'

describe SubService do

  let(:sub_service) { Factory.build(:sub_service) }
  subject { sub_service }

  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:service)}

  it do
    Factory(:sub_service, :name => subject.name, :service_id => subject.service_id)
    should validate_uniqueness_of(:name, :scope => :service_id)
  end

  it { should validate_numericality_of(:price, greater_than_or_equal_to: 0)}
  it { should validate_numericality_of(:discount, greater_than_or_equal_to: 0)}

  it "should ensure numericality of discount is less than or equal to its price" do
    Factory.build(:sub_service, :price => 1, :discount => 2).should have(1).error_on(:discount)
  end

  describe "default value" do
    its(:price) { should be_zero }
    its(:discount) { should be_zero }
  end

  [:price, :discount].each do |attrib|
    context "when #{attrib} is nil" do
      before { sub_service.send("#{attrib}=", nil) }
      describe "#valid?" do
        before { sub_service.valid? }
        its(attrib) { should be_zero }
      end
    end
  end

end