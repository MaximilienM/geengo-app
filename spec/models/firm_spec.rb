require 'spec_helper'

describe Firm do

  let(:firm) { Factory.build(:firm) }
  subject { firm }

  it "should validate presence of name" do
    Factory.build(:firm, :name => "").should have(1).error_on(:name)
  end

  it "should validate uniqueness of name" do
    f1 = Factory(:firm)
    Factory.build(:firm, :name => f1.name).should have(1).error_on(:name)
  end

  context "when created with no domains" do
    it "should create one domain based on the firm's id" do
      f = Factory(:firm)
      domain = f.domains.first
      domain.should be_a(Domain)
      domain.should be_persisted
      domain.name.should eq("domain-for-firm#{f.id}.com")
    end
  end

  context "when created with one domain set" do
    it "should not create a domain based on the firm's id" do
      f = Factory.build(:firm)
      f.domains << Factory(:domain)
      f.save!
      f.domains.count.should eq(1)
    end
  end

  it "should create its work council after create" do
    f = Factory(:firm)
    f.work_council.should be_a(WorkCouncil)
    f.work_council.should be_persisted
  end

  it "should destroy its work_council when destroyed" do
    f = Factory(:firm)
    wc = f.work_council
    f.destroy
    expect { wc.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "should destroy its employees when destroyed" do
    e = Factory(:employee)
    e.firm.destroy
    expect { e.reload }.to raise_error(ActiveRecord::RecordNotFound)
  end

  it "should destroy its domains when destroyed" do
    f = Factory(:firm)
    domains = f.domains.all
    f.destroy
    domains.each do |d|
      expect { d.reload }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  it "should destroy its sport communities when destroyed" do
    f = Factory(:firm, :sports => [Factory(:sport)])
    communities = f.sport_communities.all
    f.destroy
    expect {communities.each(&:reload)}.to raise_error(ActiveRecord::RecordNotFound)
  end

  context "with one sport community" do
    before { firm.save }
    let(:sc) { Factory(:sport_community, :firm => firm) }

    context "having one member" do
      let(:scm) { Factory(:sport_community_membership, :sport_community => sc) }

      context "#sport_ids = []" do
        before { scm; firm.sport_ids = [] }

        it "should destroy the membership" do
          expect { scm.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end

    it "has many communities_events, returning only events for the firm's communities" do
      event_for_firm = Factory(:event, :sport_id => sc.sport_id)
      other_event = Factory(:event)
      firm.communities_events.should == [event_for_firm]
    end

  end

end