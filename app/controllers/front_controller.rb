class FrontController < ApplicationController

  layout "application"

  before_filter :authenticate_employee!
  before_filter :get_in_sliders_events
  before_filter :get_current_employee_communities

  def get_in_sliders_events
    @featured_slider_events       = current_employee.firm.communities_events.in_sliders.featured
    @my_communities_slider_events = current_employee.communities_events.in_sliders.non_featured
  end

  # Protected methods
  ###################

  protected

  def current_community
    # Do nothing if no sport_name given
    return unless params[:sport_name]

    # Get the community with the given sport name in the current_employee's firm communities
    @current_community ||= current_employee.firm.sport_communities.detect {|sc| sc.name.downcase == params[:sport_name]}

    # If no community could be found, render a 404
    render :text => "404 Not Found", :status => 404 and return unless @current_community

    # Return the community if all is fine
    @current_community
  end
  helper_method :current_community

  def get_current_employee_communities
    @my_communities = current_employee.sport_communities.ordered_by_sport_name
    @missing_communities = current_employee.firm.sport_communities.ordered_by_sport_name - current_employee.sport_communities.ordered_by_sport_name
  end

end