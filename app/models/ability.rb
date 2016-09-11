class Ability
  include CanCan::Ability

  def initialize(user)

    can :access, :rails_admin

    if user.is_a?(Employee) && user.has_role?(:firm_admin)
      can :manage, Firm, :id => user.firm_id
      can :manage, Employee, :firm_id => user.firm_id
      can [:edit, :update], User, :id => user.id
    end

    if user.is_a?(Employee) && user.has_role?(:work_council_admin)
      can :manage, WorkCouncil, :firm_id => user.firm_id
      can :manage, WorkCouncilGroup, :work_council_id => user.firm.work_council.id
      can :read, Employee, :firm_id => user.firm_id
      can [:edit, :update], User, :id => user.id
    end

    if user.has_role? :infrastructure_admin
      can [:edit, :update], User, :id => user.id
      can [:read, :update], Infrastructure, :id => user.infrastructure_id
      can [:create, :read, :update, :destroy], Service, :purchasable_id => user.infrastructure_id, :purchasable_type => "Infrastructure"
      can [:create, :read, :update, :destroy], SubService, :service => {:purchasable_id => user.infrastructure_id, :purchasable_type => "Infrastructure"}
    end

    if user.has_role? :geengo_admin
      can :manage, :all

      geengo_and_super_user_common(user)

      cannot [:update, :destroy, :create], Role
      cannot :manage, Role, :name => "super_admin"
      cannot :manage, Admin, :roles => {:name => "super_admin"}
      cannot :create, SportCommunity
      cannot [:create, :destroy], WorkCouncil

      # user.employee is set in the custom employees_controller to limit models
      # listed in the select and multiselect fields
      if user.employee.present?
        cannot :read, SportCommunity
        can :read, SportCommunity, :firm_id => user.employee.firm_id
        cannot :read, WorkCouncilGroup
        can :read, WorkCouncilGroup, :work_council_id => user.employee.firm.work_council.id
      end

      [EmployeesImport, InfrastructuresImport, EventsImport].each do |import_class|
        cannot [:edit, :destroy, :export, :show], import_class
      end
      cannot [:create, :update, :destroy, :export, :see_history], ImportDiscard
      cannot [:export], Employee
    end

    if user.has_role? :super_admin
      can :manage, :all
      geengo_and_super_user_common(user)
    end

    cannot :create, SportCommunityMembership

  end

  # Private methods
  #################

  private

  def geengo_and_super_user_common(user)
    if user.import_id.present?
      cannot :read, ImportDiscard
      can :read, ImportDiscard, :import_id => user.import_id
    end

    cannot :index, User
    can :index, Employee
    can :index, Admin
  end
end