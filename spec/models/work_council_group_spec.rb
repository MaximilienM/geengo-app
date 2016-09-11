# encoding : utf-8

require 'spec_helper'

describe WorkCouncilGroup do

  describe "its name" do
    it "should be present" do
      Factory.build(:work_council_group, :name => nil).should have(1).error_on(:name)
    end

    it "should be unique (case insensitive) for a given work_council_id" do
      group = Factory(:work_council_group, :name => "QF1")
      Factory.build(:work_council_group,
        :work_council => group.work_council,
        :name => "qf1"
      ).should have(1).error_on(:name)
    end

  end

  describe "its discount_percentage" do
    it "should be present" do
      wcg = Factory.build(:work_council_group, :discount_percentage => nil)
      wcg.valid?
      wcg.errors[:discount_percentage].should include(I18n.t("errors.messages.blank"))
    end

    it "should be greater_than_or_equal_to 0" do
      Factory.build(:work_council_group, :discount_percentage => -1).should have(1).error_on(:discount_percentage)
    end

    it "should be less_than_or_equal_to 100" do
      Factory.build(:work_council_group, :discount_percentage => 101).should have(1).error_on(:discount_percentage)
    end
  end

  describe "its annual_discount_ceiling" do
    it "should be present" do
      wcg = Factory.build(:work_council_group, :annual_discount_ceiling => nil)
      wcg.valid?
      wcg.errors[:annual_discount_ceiling].should include(I18n.t("errors.messages.blank"))
    end

    it "should be greater_than_or_equal_to 0" do
      Factory.build(:work_council_group, :annual_discount_ceiling => -1).should have(1).error_on(:annual_discount_ceiling)
    end
  end

  describe "its transaction_discount_ceiling" do
    it "should be present" do
      wcg = Factory.build(:work_council_group, :transaction_discount_ceiling => nil)
      wcg.valid?
      wcg.errors[:transaction_discount_ceiling].should include(I18n.t("errors.messages.blank"))
    end

    it "should be greater_than_or_equal_to 0" do
      Factory.build(:work_council_group, :transaction_discount_ceiling => -1).should have(1).error_on(:transaction_discount_ceiling)
    end
  end

  describe "its work_council_id" do
    context "when no firm is set" do
      it "should be present" do
        Factory.build(:work_council_group, :work_council_id => nil, :firm => nil).should have(1).error_on(:work_council_id)
      end
    end

    context "when a firm is set" do
      it "can be blank" do
        f = Factory(:firm)
        Factory.build(:work_council_group, :work_council_id => nil, :firm => f).should have(:no).error_on(:work_council_id)
      end
    end
  end

  context "when work_council_id is blank" do
    it "should add an error on :firm_id" do
      Factory.build(:work_council_group, :work_council_id => nil, :firm => nil).should have(1).error_on(:firm_id)
    end
  end

  context "when new" do

    its(:discount_percentage) {should be_zero}
    its(:annual_discount_ceiling) {should be_zero}
    its(:transaction_discount_ceiling) {should be_zero}

  end

end