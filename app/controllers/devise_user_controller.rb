class DeviseUserController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super do |resource|
      is_admin = request.referrer == 'http://localhost:3000/users/admin_new'
      resource.admin_flag = is_admin
      resource.save
      # その他のカスタム処理があればここに記述します
      binding.pry
    end
  end

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:nickname, :email, :password, :password_confirmation])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:nickname, :email, :password, :current_password])
  end
end
