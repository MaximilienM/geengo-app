module FrontHelper
  
  def personal_sport_link_for_community(sport_community)
    active = sport_community == current_community ? "active" : nil

    link_to "", sport_community_path(sport_community.name.downcase), {
      :class => ["personal-sport", sport_community.name.downcase, active],
      :rel => "twipsy",
      "data-original-title" => sport_community.name.titleize
    }
  end
  
end