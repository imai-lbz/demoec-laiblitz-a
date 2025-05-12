class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :nickname, :kanji_family_name, :kanji_given_name,
      :katakana_family_name, :katakana_given_name, :birthday
    ])
  end
end
