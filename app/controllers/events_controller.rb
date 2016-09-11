class EventsController < CommunityController

  # Actions
  #########

  def index
    redirect_to root_path if params[:sport_name].present? and current_community.nil?
    @events = current_community ? current_community.events.published : current_employee.firm.communities_events.published.all
  end

  def show
    @event = Event.find params[:id]
    @messages = @event.comments.arrange(:order => "updated_at desc")
  end

end
