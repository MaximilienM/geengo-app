class InfrastructuresController < CommunityController

  # Actions
  #########

  def index
    @infrastructures = Infrastructure.where(:sport_id => current_community.sport_id)
    @infrastructures = @infrastructures.near(near_from, 10, :units => :km, :order => "distance") if near_from.present?
  end

  def show
    @infrastructure = Infrastructure.find params[:id]
    @sub_services = @infrastructure.services.map(&:sub_services).flatten
    @messages = @infrastructure.comments.arrange(:order => "updated_at desc")
  end

  # sets @near and @near_possibilities instance vars
  # @near can be "office", "home" or "other" and represents where we want the infras to be close to
  # @near_possibilities holds the 3 addresses corresponding the the @near values, for the current employee's context
  #
  # if params[:near] is unset, @near default to "office"
  #
  # return the near_possibility for @near
  def near_from
    @near = params[:near] || "office"

    @near_possibilities = {
      "office" => current_employee.firm.address,
      "home" => current_employee.full_address,
      "other" => params[:custom_address]
    }

    @near_possibilities[@near]

  end

end
