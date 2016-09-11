class SportCommunitiesController < CommunityController

  def show
    @messages = current_community.messages.arrange(:order => "updated_at desc")
    @members = current_community.members.order("sport_community_memberships.created_at desc").limit(5)
  end

end
