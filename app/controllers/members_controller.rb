class MembersController < CommunityController

  def index
    @members = current_community.members.page(params[:page])
  end

end
