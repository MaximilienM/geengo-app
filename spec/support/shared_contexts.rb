shared_context "admin is a geengo_admin" do
  let(:admin) {Factory(:geengo_admin)}
end

shared_context "signed in front" do
  let(:employee) {Factory(:confirmed_employee)}
  before {sign_in(:employee, employee)}
end
