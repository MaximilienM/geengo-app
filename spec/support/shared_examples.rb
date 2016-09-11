shared_examples "destroy associations" do
  describe "#destroy" do
    before { subject.destroy }
    it {expect {@to_destroy.reload}.to raise_error(ActiveRecord::RecordNotFound)}
  end
end
