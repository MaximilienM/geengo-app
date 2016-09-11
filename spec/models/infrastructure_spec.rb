require 'spec_helper'

describe Infrastructure do

  let(:infra) { Factory(:infrastructure) }
  subject { infra }

  it { should validate_presence_of(:sport_id) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:display_name) }
  it { should allow_values_for :venue_zip_code, "12345", nil }
  it { should_not allow_values_for :venue_zip_code, "1234", "123456" }
  it { should allow_values_for :hq_zip_code, "12345", nil }
  it { should_not allow_values_for :hq_zip_code, "1234", "123456" }

  [:hq_email, :contact_email].each do |sym|
    it { should_not allow_values_for(sym,
      "no-arobase",
      "john.doa@no-TLD",
      "@nothing-before-arobase"
    )}
  end

  [:rib_bank, :rib_office].each do |sym|
    it { should allow_values_for(sym, "0"*5) }
    it { should_not allow_values_for(sym, "0"*4, "0"*6) }
  end

  it { should allow_values_for(:rib_account, "0"*11) }
  it { should_not allow_values_for(:rib_account, "0"*10, "0"*12) }

  it { should allow_values_for(:rib_key, "0"*2) }
  it { should_not allow_values_for(:rib_key, "0"*1, "0"*3) }

  it { should allow_values_for(:iban, "0"*27) }
  it { should_not allow_values_for(:iban, "0"*26, "0"*28) }

  it { should allow_values_for(:bic, "A"*8, "A"*9, "A"*10, "A"*11) }
  it { should_not allow_values_for(:bic, "A"*7, "A"*12) }

  %w(hq_phone hq_mobile hq_fax contact_phone).each do |attrib|
    it { should validate_numericality_of attrib }
    it { should allow_values_for(    attrib, nil, "", "0"*10) }
    it { should_not allow_values_for(attrib, "0"*9, "0"*11) }
  end

  context "with one infra in the database" do
    before { @invalid = Factory.build(:infrastructure, :name => infra.name) }
    it { @invalid.should validate_uniqueness_of(:name)}
  end

  describe "#destroy" do

    before { to_destroy; infra.destroy }

    shared_examples "destroy dependencies" do
      it { expect {to_destroy.reload}.to raise_error(ActiveRecord::RecordNotFound) }
    end

    context "with one service" do
      let(:to_destroy) { Factory(:service, :purchasable => infra) }
      include_examples "destroy dependencies"
    end

    context "with one golf_course" do
      let(:to_destroy) { Factory(:golf_course, :infrastructure => infra) }
      include_examples "destroy dependencies"
    end

  end

  describe "services_attributes=" do
    before { infra.services_attributes = services_attributes }

    context "when only name is provied" do
      let(:services_attributes) {[:name => "service name"]}
      it { should have(1).services }
    end

    context "when all fields are blank" do
      let(:services_attributes) {[:name => ""]}
      it { should have(:no).services }
    end

    context "when name is blank and sub_services_attributes only have blank values" do
      let(:services_attributes) {[:name => "", :sub_services_attributes => [{:name => nil, :price => nil, :discount => nil, :eligible_conditions => nil}]]}
      it { should have(:no).services }
    end

    context "when the service and its sub_service are already persisted (ie: their :id is specified in the attributes hash)" do
      let(:services_attributes) do
        s = Factory(:service, :purchasable => infra)
        ss = Factory(:sub_service, :service => s)
        [:id => "#{s.id}", :name => s.name, :sub_services_attributes => [{:id => "#{ss.id}", :name => ss.name, :price => ss.price, :discount => ss.discount, :eligible_conditions => ss.eligible_conditions}]]
      end
      it { should have(1).services }
    end


    context "when name is blank and other infos are provided" do
      let(:services_attributes) {[:name => "", :sub_services_attributes => [{:price => 10}]]}
      it { should have(1).services }
    end

  end

  describe "courses_attributes=" do
    before { infra.courses_attributes = courses_attributes }

    context "when course name is blank" do
      let(:courses_attributes) { [{:name => ""}, {:name => nil}] }
      it { should have(:no).courses }
    end
  end

  it "defines an inverse relationship on services" do
    i = Factory.build(:infrastructure)
    i.services_attributes = [{:name => "I have no purchasable_id attribute set"}]
    i.should be_valid
  end

  describe "#sport_name=" do

    context "when a sport exists" do
      before do
        @sport = Factory(:sport)
        infra.sport_name = @sport.name
      end
      its(:sport_id) { should == @sport.id }
    end

  end

  describe "#save" do

    before { infra.save }

    context "when sti class exists for sport" do
      let(:infra) { Factory(:infrastructure, :sport => Factory(:sport, :name => "Golf")) }
      its(:type) { should == "GolfInfrastructure" }
    end

    context "when sti class does not exist for sport" do
      let(:infra) { Factory(:infrastructure, :sport => Factory(:sport, :name => "UnknownSport")) }
      its(:type) { should be_nil }
    end

  end

  describe "#full_hq_address" do

    before do
      infra.hq_address = "hq_address"
      infra.hq_zip_code = "12345"
      infra.hq_city = "hq_city"
      infra.hq_country = "hq_country"
    end

    its(:full_hq_address) { should == "hq_address, 12345 hq_city, hq_country"}

    context "when hq_country is blank" do
      before { subject.hq_country = "" }
      its(:full_hq_address) { should == "hq_address, 12345 hq_city, France"}
    end

    context "when hq_zip_code is blank" do
      before { subject.hq_zip_code = "" }
      its(:full_hq_address) { should == "hq_address, hq_city, hq_country"}
    end

    context "when hq_city is blank" do
      before { subject.hq_city = "" }
      its(:full_hq_address) { should == "hq_address, 12345, hq_country"}
    end

    context "when hq_city and hq_zip_code are blank" do
      before { subject.hq_city = subject.hq_zip_code = "" }
      its(:full_hq_address) { should == "hq_address, hq_country"}
    end

  end

  it "does something" do
    i = Infrastructure.new :other_comments => "other comments"
    i.other_comments.should == "other comments"
  end
end