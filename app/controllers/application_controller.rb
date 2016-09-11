class ApplicationController < ActionController::Base
  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = I18n.t('cancan.access_denied')
    redirect_to dashboard_path
  end

end