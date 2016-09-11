require 'spec_helper'

describe Service do

  let(:service) { Factory(:service) }
  subject { service }

  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:purchasable)}

  describe "#destroy" do
    context "with one sub_service" do
      before { @ss = Factory(:sub_service, :service => service) }
      it "should destroy the sub_service" do
        service.destroy
        expect {@ss.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "sub_services_attributes=" do
    before { service.sub_services_attributes = sub_services_attributes }

    context "when name is provied" do
      let(:sub_services_attributes) {[:name => "sub service name"]}
      it { should have(1).sub_services }
    end

    context "when all fields are blank" do
      let(:sub_services_attributes) {[:name => ""]}
      it { should have(:no).sub_services }
    end

    context "when name is blank and other infos are provided" do
      let(:sub_services_attributes) {[:name => "", :price => 10]}
      it { should have(1).sub_services }
    end
  end

  it "defines an inverse relationship on services" do
    s = Factory.build(:service)
    s.sub_services_attributes = [{:name => "I have no service_id attribute set"}]
    s.should be_valid
  end

  context "with purchasable set" do
    before { service.purchasable = Factory(:infrastructure) }

    describe "#save" do
      before { subject.save }
      its(:purchasable_type_and_id) { should == "infrastructures_#{service.purchasable_id}" }
    end

  end


end
