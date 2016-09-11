require 'spec_helper'

describe Import do

  let(:import) { Factory.build :import }
  subject { import }

  it { should validate_presence_of :file }
  its(:created_count) { should be_zero }
  its(:updated_count) { should be_zero }

  context "with one discard" do
    before do
      subject.stub(:class) { EventsImport }
      subject.file.stub(:to_attributes).and_return({})
      subject.save
      @discard = subject.discards.create Factory.attributes_for(:import_discard)
    end

    context "when destroyed" do
      before {subject.destroy}

      it "should destroy its discard" do
        expect {@discard.reload}.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

  end

  describe "#imported_class" do

    context "when type is nil (ie : we are an Import)" do
      it { expect { subject.imported_class }.to raise_error }
    end

    context "when type is not nil (ie : we are a subclass of Import)" do
      subject { EventsImport.new }
      its(:imported_class) { should == Event }
    end

  end

  describe "validation on file's content_type" do
    before { import.file.stub(:content_type) { content_type } }

    context "when csv or html" do
      ["text/csv", "text/html"].each do |content_type|
        let(:content_type) { content_type }
        it {should have(:no).error_on :file}
      end
    end

    context "when file's content_type is something else" do
      let(:content_type) { "application/zip" }
      it { should have(1).error_on :file }
    end
  end

end