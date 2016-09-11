require 'spec_helper'

describe ImportDiscard do

  describe ".description_for" do

    context "when given an invalid record" do
      before do
        @record = Firm.new
        @record.errors.add(:name, "must be set")
        @record.errors.add(:address, "must be set")
      end

      it "returns the error descriptions joined by a new line" do
        ImportDiscard.description_for(@record).should == "Nom must be set\nAdresse must be set"
      end

    end

  end

end
