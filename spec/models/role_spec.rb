require 'spec_helper'

describe Role do

  describe "its name" do
    it "should be present" do
      Factory.build(:role, :name => nil).should have(1).error_on(:name)
    end

    it "should be unique" do
      Factory(:role, :name => "geengo_admin")
      Factory.build(:role, :name => "geengo_admin").should have(1).error_on(:name)
    end
  end

end
