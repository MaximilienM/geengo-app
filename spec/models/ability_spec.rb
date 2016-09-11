require 'spec_helper'
#require "cancan/matchers"

RSpec::Matchers.define :be_able_to do |*args|
  match do |ability|
    ability.can?(*args)
  end

  failure_message_for_should do |ability|
    "expected to be able to #{args.map(&:inspect).join(" ")}"
  end

  failure_message_for_should_not do |ability|
    "expected not to be able to #{args.map(&:inspect).join(" ")}"
  end

  description do
    action = args.first
    class_or_record = args[1]

    "be able to #{action} #{class_or_record.to_s.pluralize}" if class_or_record.is_a? Class
  end

end

describe Ability do

  let(:ability) {Ability.new(user)}
  subject { ability }

  shared_examples "common abilities" do
    it { should_not be_able_to(:create, SportCommunityMembership) }
  end

  shared_examples "geengo and super_admin common" do

    it { should_not be_able_to(:index, User) }

    context "when user has an import_id context" do
      before {user.import_id = 1}

      it {should be_able_to(:read, ImportDiscard.new(:import_id => 1))}

      it "should not be_able_to read any ImportDiscard" do
        should_not be_able_to(:read, ImportDiscard.new(:import_id => 2))
      end
    end

  end

  shared_examples "firm, work_council and infra common" do
    context "when user has an import_id context" do
      before {user.import_id = 1}
      it { should_not be_able_to(:read, ImportDiscard) }
    end
  end

  context "when user is a firm_admin" do

    include_examples "common abilities"
    include_examples "firm, work_council and infra common"

    let(:user) {Factory(:firm_admin, :employee => Factory(:employee))}

    it "should be able to manage its own firm" do
      should be_able_to(:manage, user.firm)
    end

    it "should not be able to manage any other firm" do
      f = Factory(:firm)
      should_not be_able_to(:manage, f)
    end

    it "should be able to edit its own profile" do
      should be_able_to(:edit, user)
    end

    it "should be able to update its own profile" do
      should be_able_to(:update, user)
    end

  end

  context "when user has role work_council_admin" do
    let(:user) {Factory(:work_council_admin, :employee => Factory(:employee))}

    include_examples "common abilities"
    include_examples "firm, work_council and infra common"

    it { should_not be_able_to(:index, ImportDiscard) }

    it "should be able to manage the work_council for its employee's firm" do
      should be_able_to(:manage, user.firm.work_council)
    end

    it "should not be able to manage any other firm" do
      f = Factory(:work_council)
      should_not be_able_to(:manage, f)
    end

    it "should be able to manage all the work_council_groups for its employee's firm" do
      Factory.build(:work_council_group, :work_council => user.firm.work_council)
      user.firm.work_council.groups.each do |group|
        should be_able_to(:manage, group)
      end
    end

    it "should not be able to manage any work_council_group" do
      f = Factory(:work_council_group)
      should_not be_able_to(:manage, f)
    end

    it "should be able to read it's firm employees" do
      wc = Factory(:work_council)
      should be_able_to(:read, user)
    end

    it "should not be able to read any employee" do
      wc = Factory(:work_council)
      should_not be_able_to(:read, Factory(:employee))
    end

    context "without an employee" do
      before do
        @employee = user.employee
        user.employee = nil
      end

      it "should not be able to manage the work_council for its employee's firm" do
        should_not be_able_to(:manage, @employee.firm.work_council)
      end

    end

    it {should_not be_able_to(:create, EmployeesImport)}

    it "should be able to edit its own profile" do
      should be_able_to(:edit, user)
    end

    it "should be able to update its own profile" do
      should be_able_to(:update, user)
    end


  end

  context "when user is an infrastructure_admin" do
    let(:user) {Factory(:infrastructure_admin)}

    include_examples "common abilities"
    include_examples "firm, work_council and infra common"

    it "should be able to edit its own profile" do
      should be_able_to(:edit, user)
    end

    it "should be able to update its own profile" do
      should be_able_to(:update, user)
    end

    it {should_not be_able_to(:create, EmployeesImport)}

    [:read, :update].each do |action|
      it "should be able to #{action} its own infrastructure" do
        should be_able_to(action, user.infrastructure)
      end
    end

    it {should be_able_to(:create, Service)}

    context "when its infra has a service" do
      before { @service = Factory(:service, :purchasable => user.infrastructure) }

      [:read, :update, :destroy].each do |action|
        it "should be able to #{action} this service"  do
          should be_able_to(action, @service)
        end
      end

      it {should be_able_to(:create, SubService)}

      [:read, :update, :destroy].each do |action|
        it "should not be able to #{action} any sub_service" do
          should_not be_able_to(action, Factory(:sub_service))
        end
      end

      context "and a sub service" do
        before { @ss = Factory(:sub_service, :service => @service) }
        [:read, :update, :destroy].each do |action|
          it {should be_able_to(action, @ss)}
        end

      end

    end

  end

  context "when user is a geengo_admin" do
    let(:user) {Factory(:geengo_admin)}

    include_examples "common abilities"
    include_examples "geengo and super_admin common"

    it "should be able to manage all" do
      should be_able_to(:manage, :all)
    end

    it {should_not be_able_to(:update, Role)}
    it {should_not be_able_to(:destroy, Role)}
    it {should_not be_able_to(:create, Role)}

    it "should not be able to manage the super_admin Role" do
      should_not be_able_to(:manage, Factory(:role, :name => "super_admin"))
    end

    it "should not be able to manage a super_admin" do
      user = Factory(:super_admin)
      should_not be_able_to(:manage, user)
    end

    it {should_not be_able_to(:create, SportCommunity)}

    context "when user has an employee" do
      before { user.employee = Factory(:employee)}
      it "should not be able to read any SportCommunity" do
        should_not be_able_to(:read, Factory(:sport_community))
      end

      it "should not be able to read any WorkCouncilGroup" do
        should_not be_able_to(:read, Factory(:work_council_group))
      end
    end

    it {should be_able_to(:create, EmployeesImport)}

    it {should_not be_able_to(:create, WorkCouncil)}
    it {should_not be_able_to(:destroy, WorkCouncil)}

    [:destroy, :export, :show, :edit].each do |action|
      [EmployeesImport, InfrastructuresImport, EventsImport].each do |import_class|
        it {should_not be_able_to(action, import_class)}
      end
    end

    [:create, :update, :destroy, :export, :see_history].each do |action|
      it {should_not be_able_to(action, ImportDiscard)}
    end

    it { should_not be_able_to(:export, Employee)}

  end

  context "when user is a super_admin" do
    let(:user) {Factory(:super_admin)}

    include_examples "common abilities"
    include_examples "geengo and super_admin common"

    it {should be_able_to(:manage, :all)}
  end

end