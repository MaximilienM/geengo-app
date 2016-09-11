# encoding: utf-8

require 'spec_helper'

describe RailsAdmin::ImportsController do

  describe "#create" do
    let(:user) {Factory(:geengo_admin)}

    before {sign_in(user)}

    context "when file is not set" do
      subject { post :create, :model_name => "employees_imports", :employees_import => {:file => nil }}
      it { should render_template "rails_admin/main/new" }
    end

    context "when file is provided" do

      let(:file) { Rack::Test::UploadedFile.new Rails.root + "spec/examples/csv_files/issue-38.csv", "text/csv" }
      before do
        file.stub!(:to_attributes).and_return(attributes_array)
      end

      ["employees_imports", "infrastructures_imports"].each do |model_name|
        context "when importing #{model_name}" do
          let(:attributes_array) { [] }
          it "should redirect_to /admin/#{model_name}" do
            post(:create, :model_name => model_name, model_name.singularize => {:file => file})
            should redirect_to "/admin/#{model_name}"
          end
        end
      end

      context "with one new valid line" do
        let(:domain) { Factory(:domain_with_firm) }
        let(:attributes_array) { [{:email => "john.doe@#{domain.name}"}] }

        it "should set a notice flash" do
          post(:create, :model_name => "employees_imports", :employees_import => {:file => file})
          flash[:notice].should == "1 Salarié crée"
        end

      end

      context "with one updated valid line" do
        let(:employee) { Factory(:employee) }
        let(:attributes_array) { [{:email => employee.email}] }

        it "should set a notice flash" do
          post(:create, :model_name => "employees_imports", :employees_import => {:file => file})
          flash[:notice].should == "1 Salarié mis à jour"
        end

      end

      context "with a line with invalid email" do
        let(:attributes_array) { [{:email => "john.doe@invalid-domain.com"}] }

        it "flash[:error] should be '1 Abandon'" do
          post(:create, :model_name => "employees_imports", :employees_import => {:file => file})
          flash[:error].should == '1 Abandon'
        end
      end

      context "with a line with no email" do
        let(:attributes_array) { [{}] }

        it "flash[:error] should be '1 Abandon'" do
            post(:create, :model_name => "employees_imports", :employees_import => {:file => file})
            flash[:error].should == '1 Abandon'
        end
      end

      # context "with a line with inexistant work council group name" do
      #
      #   let(:domain) { Factory(:domain_with_firm) }
      #   let(:attributes_array) { [{:email => "john.doe@#{domain.name}", :work_council_group_name => "I-DO-NOT-EXIST"}] }
      #
      #   it "flash[:error] should be 'Certaines tranches QF n'existaient pas'" do
      #     post(:create, :model_name => "imports", :employees_import => {:file => file}, :type => "EmployeesImport")
      #     flash[:error].should == "Certaines #{I18n.t('activerecord.models.work_council_group.other')} n'existaient pas"
      #   end
      #
      #   context "and a line with invalid email" do
      #
      #     before { attributes_array.first[:email] = "john.doe@invalid-domain.com" }
      #
      #     it "flash[:error] should concat errors" do
      #       post(:create, :model_name => "imports", :employees_import => {:file => file}, :type => "EmployeesImport")
      #       flash[:error].should == "1 Abandon. Certaines #{I18n.t('activerecord.models.work_council_group.other')} n'existaient pas"
      #     end
      #
      #   end
      # end

    end

  end

end