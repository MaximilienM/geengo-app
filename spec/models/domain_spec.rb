require 'spec_helper'

describe Domain do

  it "should validate presence of name" do
    Factory.build(:domain, :name => "").should have(1).error_on(:name)
  end

  it "should validate uniqueness of domain" do
    o1 = Factory(:domain)
    Factory.build(:domain, :name => o1.name).should have(1).error_on(:name)
  end

  it "should validate the format of the name" do
    Factory.build(:domain, :name => "foo").should have(1).error_on(:name)
    Factory.build(:domain, :name => "my-domain.com").should have(:no).errors_on(:name)
  end

  context "when it is the last domain of its firm" do
    before do
      f = Factory(:firm)
      @d = f.domains.first
      f.domains = [@d]
    end

    it "should set an error on :base if destroyed and cancel destroy" do
      @d.destroy
      @d.errors[:base].should include("last domain for firm")
      expect { @d.reload }.to_not raise_error(ActiveRecord::RecordNotFound)
    end

  end

  context "when some firm employees have the same domain" do
    before do
      e = Factory(:employee)
      @d = e.domain_from_email
      @d.stub(:cancel_destroy_if_last_domain).and_return(true)
    end

    it "should set an error on :base if destroyed and cancel destroy" do
      @d.destroy
      @d.errors[:base].should include("employees attached to the firm use this domain in their email")
      expect { @d.reload }.to_not raise_error(ActiveRecord::RecordNotFound)
    end
  end

end
