class ContactsController < ApplicationController
  before_action :authenticate_user!, :find_user

  def new
    if !@user.has_contact?
      @contact = @user.build_contact
    else
      @contact = @user.contact
      render action: :edit
    end
  end

  def create
    @contact = @user.build_contact(contact_params)
    if @contact.save
      flash[:success] = "Contact created successfully."
      redirect_to dashboard_path
    else
      flash[:errors] = @contact.errors.full_messages
      render :new
    end
  end

  def edit
    @contact = @user.contact
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:success] = "Contact updated successfully."
      redirect_to dashboard_path
    else
      flash[:errors] = @contact.errors.full_messages
      render :edit
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :mobile, :email, :other, :office, :type, :user_id)
  end

  def find_user
    @user = User.find(params[:user_id])
  end

end
