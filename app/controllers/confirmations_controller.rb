class ConfirmationsController < Devise::ConfirmationsController

  def show
    @user = User.find_first_by_auth_conditions(confirmation_token: params[:confirmation_token])
    if @user.access_code.present?
      flash[:notice] = "Your email is already confirmed"
      redirect_to new_session_path(User)
    end
  end

  def confirm
    if params[:access_code] != "Customer Satisfaction"
      flash[:error] = "Access Code is not matching with which is provided in confirmation email."
      render action: :show
    else
      @user = User.confirm_by_token(params[:confirmation_token])
      if @user.errors.empty?
        @user.update_column(:access_code, "Customer Satisfaction")
        flash[:notice] = "Your email address is confirmed."
        redirect_to new_session_path(@user)
      else
        flash[:notice] = "Your email is already confirmed"
        redirect_to new_session_path(User)
      end
    end
  end

end