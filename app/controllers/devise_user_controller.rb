class DeviseUserController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]

  def create
    super do |resource|
      is_admin = request.referrer.present? && request.referrer.include?('/users/admin_new')

      if resource.errors.any? && is_admin
        @admin_user = resource
        render 'admin_users/new', status: :unprocessable_entity and return
      end

      resource.admin_flag = is_admin
      resource.save
      # その他のカスタム処理があればここに記述します
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
