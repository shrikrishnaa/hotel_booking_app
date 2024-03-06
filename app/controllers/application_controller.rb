class ApplicationController < ActionController::API
  include Pundit::Authorization
  include DeviseTokenAuth::Concerns::SetUserByToken
  before_action :authenticate_user!
  skip_before_action :authenticate_user!, only: [:create], if: -> { controller_name == 'registrations' }
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  rescue_from ActiveRecord::RecordNotFound, with: :show_not_found_errors
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :password_confirmation, :current_password])
  end

  private

  def show_not_found_errors(exception)
    render json: { error: exception.message }, status: :not_found
  end

  def user_not_authorized
    policy_name = exception.policy.class.to_s.underscore
    render json: { error: "Unauthorized to perform this action: #{policy_name}.#{exception.query}" }, status: :forbidden
  end
end