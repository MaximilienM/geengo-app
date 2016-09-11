require 'spec_helper'

describe GolfCourse do

  its(:length) { should be_zero }

  it { should validate_presence_of :infrastructure }
  it { should validate_presence_of :name }
  it { should validate_numericality_of(:length, greater_than_or_equal_to: 0)}

end