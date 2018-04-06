class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	before_action :configure_permitted_parameters, if: :devise_controller?

	protected

	def after_sign_in_path_for(resource_or_scope)
		@user&.contact ? dashboard_path : new_user_contact_path(@user)
	end

	def configure_permitted_parameters
		devise_parameter_sanitizer.permit(:sign_up, keys: [:fullname])
		devise_parameter_sanitizer.permit(:account_update, keys: [:fullname, :phone_number, :description, :preferred_location])
	end

end