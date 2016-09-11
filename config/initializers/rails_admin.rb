# encoding : utf-8

require "rails_admin/config/types/carrierwave_file"
require "rails_admin/config/types/carrierwave_image"
require "rails_admin/config/factories/carrierwave"

require "rails_admin/config/types/jquery_colorpicker"

class RailsAdmin::Config::Fields::Base
  include ActionView::Helpers::NumberHelper
end

RailsAdmin.config do |config|

  config.reload_between_requests = false

  config.compact_show_view = false
  config.authorize_with :cancan

  config.excluded_models << "GolfInfrastructure"
  config.excluded_models << "Message"

  # config.current_user_method do
  #   current_admin
  # end
  #
  config.model Domain do
    visible false
    edit do
      field :name
    end
  end

  config.model Role do
    visible false
    object_label_method do
      :human_name
    end
  end

  config.model Sport do
    weight 0
    field :name
    field :category
  end

  config.model GolfCourse do
    parent Infrastructure

    list do
      field :name
      field :infrastructure
      field :holes_count
      field :par
      field :length do
        pretty_value do
          v = bindings[:view]
          v.number_with_delimiter(value, :delimiter => " ") + " m"
        end
      end
    end

    edit do
      field :infrastructure
      include_all_fields
    end
  end

  config.model Firm do
    weight 1

    list do
      sort_by :name
      field :name
      field :domains
      field :sport_communities
    end

    show do
      field :name
      field :domains

      field :logo, :carrier_wave_image do
        pretty_value do
          bindings[:view].image_tag(bindings[:object].logo.url)
        end
      end

      field :complement_color, :jquery_colorpicker
      field :basecolor_color, :jquery_colorpicker

      field :employees do
        pretty_value do
          v = bindings[:view]
          options = {:filters => {:firm => {"0" => {:operator => "is", :value => bindings[:object].name}}}}
          o = bindings[:object].employees.count
          i18n_key = "activerecord.models.employee"
          if o > 0
            v.link_to v.pluralize(o, I18n.t(i18n_key + ".one"), I18n.t(i18n_key + ".other")), v.list_path(options.merge(:model_name => "employees"))
          else
            v.pluralize(o, I18n.t(i18n_key + ".one"), I18n.t(i18n_key + ".other"))
          end
        end
      end
      field :sport_communities
    end

    edit do
      field :name
      field :address
      field :logo
      field :complement_color, :jquery_colorpicker
      field :basecolor_color, :jquery_colorpicker
      field :domains do
        visible do
          bindings[:view].can? :edit, Domain
        end
      end
      field :sports do
        visible do
          bindings[:view].can? :edit, Sport
        end
      end
    end
  end

  config.model User do

    edit do
      field :email do
        read_only true
        help ''
      end
      field :password
      field :password_confirmation
    end

  end

  config.model Employee do
    weight 2

    list do
      field :first_name
      field :last_name
      field :email
      field :roles
      field :firm
    end

    show do
      field :first_name
      field :last_name
      field :email
      field :firm
      field :department
      field :work_council_group
      field :sport_community_memberships do
        pretty_value do
          v = bindings[:view]
          [value].flatten.select(&:present?).map do |associated|
            wording = associated.name_for_employee
            can_see = v.authorized?(:show, SportCommunityMembership, associated)
            can_see ? v.link_to(wording, v.show_path(:model_name => SportCommunityMembership.to_param, :id => associated.id)) : wording
          end.to_sentence.html_safe
        end
      end
      field :administrative_documents do
        pretty_value do
          v = bindings[:view]
          options = {"filters"=>{"sport_community_membership"=>{"0"=>{"operator"=>"like", "value"=>bindings[:object].name}}}}
          message = v.pluralize(bindings[:object].documents.count, I18n.t("activerecord.models.administrative_document.one"), Employee.human_attribute_name(:administrative_documents))

          if bindings[:object].documents.count.zero?
            message
          else
            v.link_to message, v.list_path(options.merge(:model_name => "administrative_documents"))
          end
        end
      end
    end

    create do
      field :first_name do
        help I18n.t('admin.new.optional')
      end
      field :last_name do
        help I18n.t('admin.new.optional')
      end
      field :email do
        help I18n.t("admin.new.required") + ". Renseigner un email valide."
      end
      field :password
      field :password_confirmation
      field :department
      field :photo, :carrier_wave_image
      field :date_of_birth do
        help I18n.t('admin.new.optional')
      end
      field :address
      field :zip_code do
        help I18n.t("admin.new.optional") + ". 5 chiffres."
      end
      field :city
      field :mobile do
        help I18n.t("admin.new.optional") + ". 10 chiffres."
      end
      field :roles
    end

    update do
      field :first_name
      field :last_name
      field :email do
        help I18n.t("admin.new.required") + ". Renseigner un email valide."
      end
      field :firm do
        read_only true
      end
      field :department
      field :work_council_group

      field :photo, :carrier_wave_image
      field :date_of_birth
      field :address
      field :zip_code do
        help I18n.t("admin.new.optional") + ". 5 chiffres."
      end
      field :city
      field :mobile do
        help I18n.t("admin.new.optional") + ". 10 chiffres."
      end

      field :confirmed_at, :date do
        visible do
          bindings[:view].can? :manage, :all
        end
      end

      field :sport_communities
      field :roles
    end

  end

  config.model Import do
    visible false
  end

  config.model EmployeesImport do
    parent Employee

    list do
      field :created_count
      field :updated_count

      field :discards do
        pretty_value do
          i18n_key = "activerecord.models.import_discard"
          nb_discards = value.count
          message = bindings[:view].pluralize(nb_discards,I18n.t("#{i18n_key}.one"),I18n.t("#{i18n_key}.other"))
          nb_discards.zero? ? message : bindings[:view].link_to(message, "/admin/imports/#{bindings[:object].id}/discards")
        end
      end

      field :created_at
    end

    create do
      field :file, :file_upload do
        help I18n.t('admin.new.required')
        partial :file_upload_with_errors
      end
    end
  end

  config.model ImportDiscard do
    visible false

    list do
      field :identifier
      field :description do
        pretty_value do
          bindings[:view].simple_format value
        end
      end
    end
  end

  config.model AdministrativeDocument do

    weight 3

    list do
      field :document do
        searchable false
      end
      field :kind do
        pretty_value do
          I18n.t("activerecord.administrative_documents.kinds." + bindings[:object].kind) if bindings[:object].kind?
        end
      end
      field :sport_community_membership
      field :accepted
    end

    create do
      field :document do
        help I18n.t('admin.new.required')
      end
      field :kind, :enum do
        enum_method do
          :availables_kinds
        end
      end
      field :sport_community_membership
      field :accepted
      field :valid_until
    end

    update do
      field :document do
        help I18n.t('admin.new.required')
      end
      field :kind, :enum do
        enum_method do
          :availables_kinds
        end
      end
      field :sport_community_membership do
        read_only true
        help ""
      end
      field :accepted
      field :valid_until
    end

  end

  config.model WorkCouncil do
    weight 4

    list do
      field :firm
      field :annual_discount_ceiling do
        pretty_value do
          number_to_currency value/1000, :unit => "k&euro;", :format => "%n %u"
        end
      end
    end

    show do
      field :annual_discount_ceiling do
        pretty_value do
          number_to_currency value/1000, :unit => "k&euro;", :format => "%n %u"
        end
      end
      field :firm
    end

    update do
      field :annual_discount_ceiling
      field :firm do
        read_only true
      end
    end
  end

  config.model WorkCouncilGroup do

    weight 5

    list do

      sort_by :work_council

      field :work_council
      field :name
      field :discount_percentage do
        pretty_value do
          number_to_percentage value, :precision => 0
        end
      end
      field :transaction_discount_ceiling do
        pretty_value do
          number_to_currency value, :unit => "&euro;", :format => "%n %u"
        end
      end
      field :annual_discount_ceiling do
        pretty_value do
          number_to_currency value/1000, :unit => "k&euro;", :format => "%n %u"
        end
      end
    end

    show do
      field :name
      field :discount_percentage do
        pretty_value do
          number_to_percentage(value, :precision => 0)
        end
      end
      field :transaction_discount_ceiling do
        pretty_value do
          number_to_currency value, :unit => "&euro;", :format => "%n %u"
        end
      end
      field :annual_discount_ceiling do
        pretty_value do
          number_to_currency value/1000, :unit => "k&euro;", :format => "%n %u"
        end
      end
      field :work_council
    end

    create do
      field :name
      field :discount_percentage, :enum do
        enum (0..100).to_a.reject {|e| e%5 != 0}
      end
      field :transaction_discount_ceiling
      field :annual_discount_ceiling
      field :work_council
    end

    update do
      field :work_council do
        read_only true
        help ""
      end
      field :name
      field :discount_percentage, :enum do
        enum (0..100).to_a.reject {|e| e%5 != 0}
      end
      field :transaction_discount_ceiling
      field :annual_discount_ceiling
    end
  end

  config.model Admin do
    weight 10

    list do
      field :email do
        pretty_value do
          bindings[:object].email
        end
      end
      field :roles
    end

    show do
      field :email do
        pretty_value do
          bindings[:object].email
        end
      end
      field :roles
    end

    edit do
      field :email
      field :password
      field :password_confirmation
      field :roles do
        visible do
          bindings[:view].can? :read, Role
        end
      end
      field :infrastructure
    end
  end

  config.model Infrastructure do

    weight 6

    list do
      field :name
      field :display_name
      field :sport
      field :services do
        pretty_value do
          v = bindings[:view]
          count = bindings[:object].services.count
          i18n_key = 'activerecord.models.service'
          wording = v.pluralize(count, I18n.t("#{i18n_key}.one"), I18n.t("#{i18n_key}.other"))

          options = count.zero? ? {} : {:filters => {purchasable_type_and_id: {"0" => {"operator"=>"is", "value"=> "#{bindings[:object].class.table_name}_#{bindings[:object].id}" }}}}
          v.link_to wording, v.list_path(options.merge(:model_name => "services"))
        end
      end

      field :autre do
        pretty_value do
          if bindings[:object].is_a? GolfInfrastructure
            courses_count = bindings[:object].courses.count
            i18n_key = "activerecord.attributes.golf_infrastructure.courses"
            wording = [courses_count, I18n.t(i18n_key)].join(' ')
            v = bindings[:view]

            options = courses_count.zero? ? {} : {:filters => {infrastructure: {"0" => {"operator"=>"is", "value"=> bindings[:object].name }}}}
            v.link_to wording, v.list_path(options.merge(:model_name => "golf_courses"))
          end
        end
      end

      field :kind
    end

    show do
      group :default do
        field :sport
        field :kind
        field :name
        field :display_name

        field :logo, :carrier_wave_image do
          pretty_value do
            bindings[:view].image_tag(bindings[:object].logo.show.url)
          end
        end

        field :description
      end

      group :head_office do
        label "Informations du Siege Social".upcase
        field :hq_address
        field :hq_address
        field :hq_zip_code
        field :hq_city
        field :hq_country
        field :hq_phone
        field :hq_mobile
        field :hq_fax
        field :hq_email
        field :hq_url
      end

      group :contact do
        label "Contact".upcase
        field :contact_name
        field :contact_role
        field :contact_phone
        field :contact_email
      end

      group :bank do
        label "Informations bancaires".upcase
        field :rib_bank
        field :rib_office
        field :rib_account
        field :rib_key
        field :rib_owner_name
        field :rib_owner_address
        field :iban
        field :bic
      end

      group :venue do
        label "Lieu de pratique".upcase
        field :venue_name
        field :venue_address
        field :venue_zip_code
        field :venue_city
        field :venue_country
      end

      group :other do
        label "Informations complémentaires".upcase
        field :accessible
        field :practical_informations
        field :opening_hours
        field :equipments

        [:picture_1, :picture_2, :picture_3].each do |attrib|
          field attrib, :carrier_wave_image do
            pretty_value do
              bindings[:view].image_tag(bindings[:object].send(attrib).show.url)
            end
          end
        end

        field :other_comments
        field :geengo_comments
      end
    end

    edit do
      group :default do
        field :sport
        field :kind do
          help "#{I18n.t('admin.new.optional')}. Club, association, infrastructure municipale, etc ..."
        end
        field :name
        field :display_name
        field :logo
        field :description
      end

      group :head_office do
        label "Informations du Siege Social".upcase
        field :hq_address
        field :hq_address
        field :hq_zip_code do
          help I18n.t("admin.new.optional") + ". 5 chiffres."
        end
        field :hq_city
        field :hq_country
        field :hq_phone do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :hq_mobile do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :hq_fax do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :hq_email do
          help I18n.t("admin.new.optional") + ". Renseigner un email valide."
        end
        field :hq_url
      end

      group :contact do
        label "Contact".upcase
        field :contact_name
        field :contact_role
        field :contact_phone do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :contact_email do
          help I18n.t("admin.new.optional") + ". Renseigner un email valide."
        end
      end

      group :bank do
        label "Informations bancaires".upcase
        field :rib_bank
        field :rib_office
        field :rib_account
        field :rib_key
        field :rib_owner_name
        field :rib_owner_address
        field :iban
        field :bic
      end

      group :venue do
        label "Lieu de pratique".upcase
        field :venue_name
        field :venue_address
        field :venue_zip_code do
          help I18n.t("admin.new.optional") + ". 5 chiffres."
        end
        field :venue_city
        field :venue_country
      end

      group :other do
        label "Informations complémentaires".upcase
        field :accessible
        field :practical_informations
        field :opening_hours
        field :equipments
        field :picture_1
        field :picture_2
        field :picture_3
        field :other_comments
        field :geengo_comments
      end
    end
  end

  config.model Service do

    weight 8

    list do
      field :name

      field :purchasable do
        pretty_value do
          v = bindings[:view]
          v.link_to value.name, v.edit_path(:model_name => value.class.table_name, :id => value.id)
        end
      end

      field :purchasable_type do
        pretty_value do
          key = value == "Event" ? "event" : "infrastructure"
          I18n.t("activerecord.models.#{key}.one")
        end
      end

      field :sub_services do
        pretty_value do
          v = bindings[:view]
          options = {"filters"=>{"service"=>{"0"=>{"operator"=>"is", "value"=>bindings[:object].id}}}}
          message = v.pluralize(bindings[:object].sub_services.count, I18n.t("activerecord.models.sub_service.one"), I18n.t("activerecord.models.sub_service.other"))
          if bindings[:object].sub_services.count.zero?
            message
          else
            v.link_to message, v.list_path(options.merge(:model_name => "sub_services"))
          end
        end
      end

      field :purchasable_type_and_id
    end

    create do
      field :purchasable
      field :name
    end

    update do
      field :purchasable
      field :name
      field :sub_services
    end

  end

  config.model InfrastructuresImport do

    parent Infrastructure

    list do
      field :created_count
      field :updated_count

      field :discards do
        pretty_value do
          i18n_key = "activerecord.models.import_discard"
          nb_discards = value.count
          message = bindings[:view].pluralize(nb_discards,I18n.t("#{i18n_key}.one"),I18n.t("#{i18n_key}.other"))
          nb_discards.zero? ? message : bindings[:view].link_to(message, "/admin/imports/#{bindings[:object].id}/discards")
        end
      end

      field :created_at
    end

    create do
      field :file, :file_upload do
        help I18n.t('admin.new.required')
        partial :file_upload_with_errors
      end
    end

  end

  config.model SubService do

    parent Service

    list do
      field :service do
        searchable [:name, :id]
      end
      field :name
      field :price do
        pretty_value do
          bindings[:view].number_to_currency value
        end
      end
      field :discount do
        pretty_value do
          bindings[:view].number_to_currency value
        end
      end
    end

    edit do
      field :service
      field :name
      field :price
      field :discount
      field :eligible_conditions
    end
  end

  config.model Event do
    weight 7

    list do
      field :name
      field :sport
      field :starts_at, :date
      field :ends_at, :date

      field :services do
        pretty_value do
          v = bindings[:view]
          count = bindings[:object].services.count
          i18n_key = 'activerecord.models.service'
          wording = v.pluralize(count, I18n.t("#{i18n_key}.one"), I18n.t("#{i18n_key}.other"))

          options = count.zero? ? {} : {:filters => {purchasable_type_and_id: {"0" => {"operator"=>"is", "value"=> "#{bindings[:object].class.table_name}_#{bindings[:object].id}" }}}}
          v.link_to wording, v.list_path(options.merge(:model_name => "services"))
        end
      end

    end

    show do
      group :default do
        field :sport
        field :name
        field :starts_at
        field :ends_at
        field :description do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
        field :short_description do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
      end

      group :detailed do
        label "Précisions".upcase
        field :target
        field :nature
        field :kind, :enum
        field :game_kind, :enum
        field :player_category, :enum
        field :participation_terms do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
        field :max_players_count
        field :max_team_players_count
      end

      group :venue do
        label "Lieu de l'évènement".upcase
        field :venue_name
        field :venue_phone
        field :venue_address
        field :venue_zip_code
        field :venue_city
        field :venue_country
        field :travel_informations do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
        field :arrival_address
        field :arrival_zip_code
        field :arrival_city
        field :arrival_country
      end

      group :other do
        label "Informations complémentaires".upcase
        field :scale
        field :website_url
        field :brochure_image, :carrier_wave_image do
          pretty_value do
            bindings[:view].image_tag(bindings[:object].brochure_image.url)
          end
        end
      end

      group :registration do
        label "Inscription et réservation".upcase
        field :registration_strategy
        field :payment_terms do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
        field :registration_starts_on
        field :pfs_registration_ends_on
        field :registration_ends_on
        field :registration_email
        field :registration_mail do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
        field :practical_informations do
          pretty_value do
            value.gsub("\n", "<br />").html_safe if value
          end
        end
      end

      group :contact do
        label "Contact".upcase
        field :organizer_name
        field :organizer_contact
        field :organizer_phone
        field :organizer_email
        field :organizer_address
        field :organizer_zip_code
        field :organizer_city
        field :organizer_rib
      end

      group :geengo do
        label "Geengo".upcase
        field :broadcast_starts_on
        field :broadcast_ends_on
        field :featured
      end
    end

    edit do

      group :default do
        field :sport
        field :name
        field :starts_at
        field :ends_at
        field :description
        field :short_description
      end

      group :detailed do
        label "Précisions".upcase
        field :target, :enum do
          enum do
            ["Seniors", "Jeunes", "-25 ans", "+60 ans"]
          end
        end
        field :nature, :enum do
          enum do
            ["Individuel", "Par équipe"]
          end
        end
        field :kind, :enum do
          enum do
            ["Championat", "Tournoi", "Coupe", "Critérium"]
          end
        end
        field :game_kind, :enum do
          enum do
            ["Scramble (golf)", "5x5 (basket)"]
          end
        end
        field :player_category, :enum do
          enum do
            ["Messieurs", "Dames" "Mixte"]
          end
        end
        field :participation_terms
        field :max_players_count
        field :max_team_players_count
      end

      group :venue do
        label "Lieu de l'évènement".upcase
        field :venue_name
        field :venue_phone do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :venue_address
        field :venue_zip_code do
          help I18n.t("admin.new.optional") + ". 5 chiffres."
        end
        field :venue_city
        field :venue_country
        field :travel_informations
        field :arrival_address
        field :arrival_zip_code do
          help I18n.t("admin.new.optional") + ". 5 chiffres."
        end
        field :arrival_city
        field :arrival_country
      end

      group :other do
        label "Informations complémentaires".upcase
        field :scale
        field :website_url
        field :brochure_image, :carrier_wave_image do
          help "202 x 274 pixels"
        end
      end

      group :registration do
        label "Inscription et réservation".upcase
        field :registration_strategy, :enum do
          enum do
            ["En ligne", "Par courrier", "Par mail", "Par téléphone"]
          end
        end
        field :payment_terms
        field :registration_starts_on
        field :pfs_registration_ends_on
        field :registration_ends_on
        field :registration_email do
          help I18n.t("admin.new.optional") + ". Renseigner un email valide."
        end
        field :registration_mail
        field :practical_informations
      end

      group :contact do
        label "Contact".upcase
        field :organizer_name
        field :organizer_contact
        field :organizer_phone do
          help I18n.t("admin.new.optional") + ". 10 chiffres."
        end
        field :organizer_email
        field :organizer_address
        field :organizer_zip_code do
          help I18n.t("admin.new.optional") + ". 5 chiffres."
        end
        field :organizer_city
        field :organizer_rib
      end

      group :geengo do
        label "Geengo".upcase
        field :broadcast_starts_on
        field :broadcast_ends_on
        field :featured
      end
    end
  end

  config.model EventsImport do

    parent Event

    list do
      field :created_count
      field :updated_count

      field :discards do
        pretty_value do
          i18n_key = "activerecord.models.import_discard"
          nb_discards = value.count
          message = bindings[:view].pluralize(nb_discards,I18n.t("#{i18n_key}.one"),I18n.t("#{i18n_key}.other"))
          nb_discards.zero? ? message : bindings[:view].link_to(message, "/admin/imports/#{bindings[:object].id}/discards")
        end
      end

      field :created_at
    end

    create do
      field :file, :file_upload do
        help I18n.t('admin.new.required')
        partial :file_upload_with_errors
      end
    end

  end


  config.model SportCommunity do
    visible false
  end

  config.model SportCommunityMembership do
    visible false

    list do
      field :sport_community
      field :employee
      field :level do
        pretty_value do
          value ? I18n.t("activerecord.sport_community_membership.level.#{value}") : nil
        end
      end
    end

    edit do
      field :sport_community do
        read_only true
        help ''
      end
      field :employee do
        read_only true
        help ''
      end
      field :level, :enum do
        enum do
          I18n.t("activerecord.sport_community_membership.level").invert
        end
      end
      field :position

      field :licence_number
      field :ranking
    end
  end

end