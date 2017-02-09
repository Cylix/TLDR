class ApplicationController < ActionController::Base

  # csrf
  protect_from_forgery with: :exception

  # devise strong parameters
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  # devise strong parameters
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name])
  end

end
