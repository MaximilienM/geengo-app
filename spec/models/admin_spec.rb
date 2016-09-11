require 'spec_helper'

RSpec::Matchers.define :have_role do |expected|
  match do |user|
    user.has_role?(expected)
  end
end

describe Admin do

end