require 'spec_helper'

describe Employee do

  let(:employee) { Factory(:employee) }
  subject { employee }

  it { should validate_presence_of(:email) }
  it { should_not allow_values_for(:email,
    "no-arobase",
    "john.doa@no-TLD",
    "@nothing-before-arobase",
    "john.doa@inexistant-domain.com"
  )}

  # fails and I don't know why ...
  # it { should validate_presence_of(:firm_id) }
  describe "its firm_id" do
    it "should be present" do
      Factory.build(:employee, :firm_id => nil).should have(1).error_on(:firm_id)
    end
  end

  context "with one work council groups attached to the employee's firm" do
    let(:group) { Factory(:work_council_group, :work_council => employee.firm.work_council) }
    it { should allow_values_for(:work_council_group_id, group.id)}
  end

  context "with one employee in the database" do
    before { Factory(:employee) }
    it { should validate_uniqueness_of(:email)}
  end

  context "when confirmed" do
    before { subject.stub(:confirmed?).and_return(true)}
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_presence_of(:date_of_birth) }
  end

  its(:domain_from_email) { should be_a(Domain) }

  context "when firm is not set" do
    before { subject.firm = nil }

    it "validation should set it from email" do
      subject.valid?
      subject.firm.should be_present
    end
  end

  context "when mobile field is set" do
    it {should_not allow_values_for :mobile, "123456789", "12345678901"}
    it {should allow_values_for :mobile, "1234567890", nil}
  end

  describe "before_validation" do

    context "when work_council_group_id is unchanged" do
      it "should set work_council_group_id from @work_council_group_name (what ever the case 'qf1' or 'QF1')" do
        old_group = Factory(:work_council_group)
        new_group = Factory(:work_council_group, :work_council_id => old_group.work_council_id, :name => "foo")
        e = Factory(:employee, :firm => old_group.firm, :work_council_group_id => old_group.id)
        e.work_council_group_name = "FOO"
        e.valid?
        e.work_council_group_id.should == new_group.id
      end

    end

    context "when work_council_group_id has been changed" do
      it "should not modifiy work_council_group_id from @work_council_group_name" do
        old_group = Factory(:work_council_group)
        new_group = Factory(:work_council_group, :work_council_id => old_group.work_council_id)
        e = Factory.build(:employee, :firm => old_group.firm)
        e.work_council_group_id = old_group.id
        e.work_council_group_name = new_group.name
        e.valid?
        e.work_council_group_id.should == old_group.id
      end
    end

    context "when work_council_group_name does not exist" do
      before { employee.work_council_group_name = "I do not exist" }
      it { should have(1).error_on(:work_council_group_name) }
    end

  end

  context "with one sport_community_membership" do
    before { @membership = Factory(:sport_community_membership, :employee => subject) }

    describe "#destroy" do
      before { subject.destroy }

      it "should destroy the membership" do
        expect {@membership.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  context "with one message" do
    before { @to_destroy = Factory(:message, :employee => employee) }

    describe "#destroy" do
      before { subject.destroy }

      it "should destroy the message" do
        expect {@to_destroy.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  [:first_name, :last_name, :date_of_birth].each do |attribute|
    context "when #{attribute} is not set" do
      before { employee.send("#{attribute}=", nil)}
      it { should_not be_registered }
    end
  end

  it "should not require confirmation if skip_confirmation is true" do
    subject.skip_confirmation = true
    subject.should_not be_confirmation_required
  end

  context "when zip_code is set" do
    it {should_not allow_values_for(:zip_code, "1234", "123456")}
    it {should allow_values_for(:zip_code, "12345", nil)}
  end

  context "with a work_council_group" do
    before do
      g = Factory(:work_council_group, :work_council => employee.firm.work_council)
      employee.update_attribute(:work_council_group_id, g.id)
    end

    describe "#save" do
      before { employee.save }
      its(:work_council_group_id) { should_not be_nil}
    end
  end

  context "with one community membership" do
    let(:scm) { Factory(:sport_community_membership, :employee => employee) }

    context "having one document" do
      let(:doc) { Factory(:administrative_document, :sport_community_membership => scm) }

      context "#sport_community_ids = []" do
        before { doc; employee.sport_community_ids = [] }

        it "should destroy the document" do
          expect { doc.reload }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end

end