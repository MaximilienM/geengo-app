require 'spec_helper'

describe Message do

  it { should validate_presence_of :sport_community_id }
  it { should validate_presence_of :employee_id }
  it { should validate_presence_of :content }

end
