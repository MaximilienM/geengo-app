FactoryGirl.define do

  factory :firm do
    sequence(:name) { |n| "firm#{n}"}
  end

  factory :employee do
    firm
    sequence(:email) {|n| "employee#{n}@firm-domain.fr"}
    first_name "John"
    last_name "Doe"
    password "sdfsdf"
    date_of_birth "01-01-2011"

    after_build do |employee|
      employee.email.try :gsub!, "firm-domain.fr", employee.firm.try(:domains).try(:first).try(:name) || ""
    end

    %w(firm_admin work_council_admin).each do |role|
      factory role.to_sym do
        after_build do |admin|
          admin.roles = [
            Factory(:role, :name => role)
          ]
        end
      end
    end

    factory :confirmed_employee do
      after_create do |employee|
        employee.confirm!
      end
    end

  end

  factory :admin do
    sequence(:email) {|n| "user#{n}@example.com"}
    password "sdfsdf"

    %w(super_admin geengo_admin).each do |role|
      factory role.to_sym do
        after_build do |admin|
          admin.roles = [
            Factory(:role, :name => role)
          ]
        end
      end
    end

    factory :infrastructure_admin do
      infrastructure
      after_build do |admin|
        admin.roles = [
          Factory(:role, :name => "infrastructure_admin")
        ]
      end
    end

  end

  factory :user_linked_to_employee, :class => User do
    employee
  end

  factory :domain do
    sequence(:name) {|n| "domain#{n}.fr"}
    factory :domain_with_firm do
      firm
    end
  end

  factory :work_council do
    firm
    annual_discount_ceiling 0

    # HACK : firm creates its work council after create
    # so here, Factory(:work_council) would create 2 work_councils with the same firm
    # this is buggy, and not valid since work_council has a unique validation on its firm_id
    after_build do |wc|
      WorkCouncil.destroy wc.firm.work_council if wc.firm
    end
  end

  factory :work_council_group do
    work_council
    sequence(:name) {|n|"QF_#{n}"}
  end

  factory :sport do
    sequence(:name) { |n| "sport#{n}"}
  end

  factory :infrastructure do
    sport
    sequence(:name) { |n| "name#{n}"}
    display_name "display name"
  end

  factory :sport_community do
    firm
    sport
  end

  factory :sport_community_membership do
    employee
    sport_community
  end

  factory :administrative_document do
    sport_community_membership
    document do
      f = Tempfile.new(["foo", ".jpg"])
      f.puts "binary"
      f.close
      f
    end
  end

  factory :role do
  end

  factory :import do
    file { Rack::Test::UploadedFile.new Rails.root + "spec/examples/csv_files/issue-38.csv", "text/csv" }
  end

  factory :import_discard do
  end

  factory :service do
    name "service name"
    association :purchasable, :factory => :infrastructure
  end

  factory :sub_service do
    name "sub service name"
    service
  end

  factory :golf_course do
    name "course name"
    infrastructure
  end

  factory :event do

    name "event name"
    sport
    starts_at { Time.now }
    ends_at { starts_at + 1.hour }

    trait :featured do
      featured true
    end

    trait :published do
      broadcast_starts_on { Date.today - 1.day }
      broadcast_ends_on { Date.today + 1.day }
    end

    factory :featured_event, :traits => [:featured]
    factory :published_event, :traits => [:published]
    factory :published_featured_event, :traits => [:published, :featured]
  end

  factory :message do
    content "my content"
    sport_community
    employee
  end

end