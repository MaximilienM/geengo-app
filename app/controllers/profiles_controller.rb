# encoding : utf-8

class ProfilesController < FrontController

  # Actions
  #########

  def show
    @messages = current_employee.sport_communities.map(&:messages).inject({}) do |memo, messages|
      memo.merge(messages.arrange(:order => :updated_at))
    end

    sorted_messages = @messages.sort_by do |message, replies|
      message.updated_at
    end.reverse

    @messages = Hash[sorted_messages]

    render :layout => "application"
  end

  def perso
  end

  def password
  end

  def sports
    @my_memberhips = current_employee.sport_community_memberships.ordered_by_sport_name
  end

  def documents
    @doc = AdministrativeDocument.new
  end

  def update

    all_pwd_blank = [:current_password, :password, :password_confirmation].inject(true) do |memo, attribute|
      memo && params[:employee][attribute].blank?
    end

    result = if params[:employee][:current_password]
      current_employee.update_with_password(params[:employee])
    else
      current_employee.update_without_password(params[:employee])
    end

    referer_action = request.env["HTTP_REFERER"].split('/').last
    referer_action = %(perso password documents sports).include?(referer_action) ? referer_action : "perso"

    if result
      redirect_to "/profile/#{referer_action}", :notice => "Modifications enregistrées"
    else
      flash.now[:alert] = "Merci de corriger les erreurs suivantes"
      render referer_action
    end
  end

end