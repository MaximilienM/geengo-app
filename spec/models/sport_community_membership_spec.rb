require 'spec_helper'

describe SportCommunityMembership do

  let(:scm) { Factory.build(:sport_community_membership) }
  subject { scm }

  it { should validate_presence_of(:sport_community_id) }
  it { should validate_presence_of(:employee_id) }

  context "with one administrative document" do
    before { scm.save; @doc = Factory(:administrative_document, :sport_community_membership => scm) }
    describe "#destroy" do
      before { scm.destroy }
      it "should destroy the document" do
        expect {@doc.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "#valid?" do
    before { scm.valid? }
    it "should set name" do
      subject.name.should_not be_nil
    end
  end

end