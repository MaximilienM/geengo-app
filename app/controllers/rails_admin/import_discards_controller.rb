class RailsAdmin::ImportDiscardsController < RailsAdmin::MainController

  def _current_user
    user = super
    user.import_id = params[:import_id]
    user
  end

end
