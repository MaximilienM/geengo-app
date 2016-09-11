class SportCommunityMembershipsController < FrontController
  
  respond_to :html, :json
  
  def create
    @membership = current_employee.sport_community_memberships.build params[:sport_community_membership]

    if @membership.save
      redirect_to request.env["HTTP_REFERER"]
    else
      raise @membership.errors.inspect
    end
  end

  def update
    @membership = SportCommunityMembership.find params[:id]

    if @membership.update_attributes(params[:sport_community_membership])
      respond_with @membership
    end
  end
  
  def destroy
    @membership = SportCommunityMembership.find params[:id]
    @membership.destroy
    redirect_to request.env["HTTP_REFERER"]
  end

end
