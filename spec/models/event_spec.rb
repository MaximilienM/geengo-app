require 'spec_helper'

describe Event do

  let(:event) { Factory(:event) }
  subject { event }

  it { should validate_presence_of :name }
  it { should validate_presence_of :sport_id }
  it { should validate_presence_of :starts_at }
  it { should validate_presence_of :ends_at }

  [:registration_email, :organizer_email].each do |email|
    it { should allow_values_for(email, nil, "", "john@domain.com") }
    it { should_not allow_values_for(email, "no-at", "john@no-TLD", "@nothing-before-at") }
  end

  it { should validate_numericality_of :max_players_count }
  it { should validate_numericality_of :max_team_players_count }

  [:venue_zip_code, :arrival_zip_code, :organizer_zip_code].each do |zip|
    it { should allow_values_for(zip, nil, "", "12345") }
    it { should_not allow_values_for(zip, "1234", "123456") }
  end

  [:venue_phone, :organizer_phone].each do |phone|
    it { should allow_values_for(phone, nil, "", "0123456789") }
  end

  context "when ends_at is less than starts_at" do
    before { event.ends_at = event.starts_at}
    it { should have(1).error_on(:ends_at)}
  end

  [:registration, :broadcast].each do |sym|
    context "when #{sym}_ends_on is less than #{sym}_starts_on" do
      before { event.send("#{sym}_starts_on=", Date.today); event.send("#{sym}_ends_on=", Date.today - 1)}
      it { should have(1).error_on("#{sym}_ends_on")}
    end
  end

  describe "#duration" do
    context "when ends_at is 1 hour after starts_at" do
      before { event.starts_at = Time.now; event.ends_at = event.starts_at + 1.hour }
      its(:duration) { should == 1.hour }
    end
  end

  describe "#sport_name=" do

    context "when a sport exists" do
      before do
        @sport = Factory(:sport)
        event.sport_name = @sport.name
      end
      its(:sport_id) { should == @sport.id }
    end

  end

  describe "#destroy" do

    before { service; event.destroy }

    context "with one service" do
      let(:service) { Factory(:service, :purchasable => event) }
      it { expect {service.reload}.to raise_error(ActiveRecord::RecordNotFound) }
    end

  end

  describe "services_attributes=" do
    before { event.services_attributes = services_attributes }

    context "when only name is provied" do
      let(:services_attributes) {[:name => "service name"]}
      it { should have(1).services }
    end

    context "when all fields are blank" do
      let(:services_attributes) {[:name => ""]}
      it { should have(:no).services }
    end

    context "when name is blank and other infos are provided" do
      let(:services_attributes) {[:name => "", :sub_services_attributes => [{:price => 10}]]}
      it { should have(1).services }
    end

  end

  it "defines an inverse relationship on services" do
    e = Factory.build(:event)
    e.services_attributes = [{:name => "I have no purchasable_id attribute set"}]
    e.should be_valid
  end

  context "with one featured and one non featured event" do
    before { @featured = Factory(:featured_event); @non_featured = Factory(:event) }
    it { Event.featured.should == [@featured] }
    it { Event.non_featured.should == [@non_featured] }
  end

  describe ".published" do
    context "with one published and one unpublished event" do
      before { @published = Factory(:published_event); Factory(:event) }
      it { Event.published.should == [@published] }
    end
  end

  describe ".in_sliders" do

    subject { Event.in_sliders }

    context "with 6 published events" do
      before { 6.times { Factory(:published_event) } }
      it { should have(5).items }
    end

    it "should order events by pfs_registration_ends_on desc" do
      thrid, first, second = [2, 0, 1].map {|i| Factory(:published_event, :pfs_registration_ends_on => Date.today - i)}
      should == [first, second, thrid]
    end

  end

end
