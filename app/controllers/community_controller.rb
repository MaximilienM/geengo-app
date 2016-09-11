class CommunityController < FrontController

  # Filters
  #########

  def default_url_options(options={})
    return options if Rails.env.test?
    options.merge!({ :sport_name => current_community.name.downcase }) if current_community
    options
  end

  def get_in_sliders_events
    return unless current_community

    @featured_slider_events       = current_community.events.in_sliders.featured
    @my_communities_slider_events = current_community.events.in_sliders.non_featured

    # Handle the case when no events were found
    @my_communities_slider_events = Event.in_sliders.non_featured.limit(1) if @my_communities_slider_events.empty?
    @featured_slider_events       = Event.in_sliders.featured.limit(1) if @featured_slider_events.empty?
  end
  
end