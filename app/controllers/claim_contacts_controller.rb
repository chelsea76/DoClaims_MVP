class ClaimContactsController < ApplicationController
  before_action :authenticate_user!, :find_claim

  def index
    @contacts = @claim.contacts
  end

  def new
    @contact = @claim.contacts.new
  end

  def create
    @contact = @claim.contacts.new(contact_params)
    if @contact.save
      @claim.contacts << @contact
      flash[:success] = "Contact created successfully."
      redirect_to claim_contacts_path(@claim)
    else
      flash[:errors] = @contact.errors.full_messages
      render :new
    end
  end

  def edit
    @contact = Contact.find(params[:id])
  end

  def update
    @contact = Contact.find(params[:id])
    if @contact.update_attributes(contact_params)
      flash[:success] = "Contact updated successfully."
      redirect_to claim_contacts_path(@claim)
    else
      flash[:errors] = @contact.errors.full_messages
      render :edit
    end
  end

  def show
    @contact = Contact.find(params[:id])
  end

  def pick_contact
  end

  def existing_contacts
    contact_ids = @claim.contacts.pluck(:id)
    contacts = Contact.existing_contacts(params[:term], contact_ids).pluck(:firstname, :lastname, :email, :id)
    result = contacts.size > 0 ? contacts.inject([]) {|res, user| res << { label: (user[0] + ' ' +user[1]), value: user[2], id: user[3] }; res} : [{value: params[:term], label: "No Contacts Found"}]
    render json: result
  end

  def save_contact
    if params[:contact_id].present?
      contact = Contact.find(params[:contact_id])
      @claim.contacts << contact
      flash[:success] = "Contact added successfully"
      redirect_to claim_contacts_path(@claim)
    else
      flash[:error] = "Please select any contact first"
      redirect_to pick_contact_claim_contacts_path(@claim)
    end
  end

  def destroy
    @contact = Contact.find(params[:id])
    @claim.contacts.delete(@contact)
    flash[:success] = "Contact deleted successfully."
    redirect_to claim_contacts_path(@claim)
  end

  private

  def contact_params
    params.require(:contact).permit(:firstname, :lastname, :mobile, :email, :other, :office, :type, :claim_id, :preferred_method)
  end

  def find_claim
    @claim = Claim.find(params[:claim_id])
  end
end
