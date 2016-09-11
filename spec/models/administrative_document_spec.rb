require 'spec_helper'

describe AdministrativeDocument do

  subject { Factory.build(:administrative_document) }

  describe "document" do
    it "should be present" do
      subject.remove_document!
      should have(1).error_on(:document)
    end
  end

  describe "sport_community_membership_id" do

    it "should be present" do
      subject.sport_community_membership_id = nil
      should have(1).error_on(:sport_community_membership_id)
    end

  end

  describe "when new" do
    its(:accepted) { should be_false }
  end

end