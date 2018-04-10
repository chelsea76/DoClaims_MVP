class ClaimsController < ApplicationController
  before_action :set_claim, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:show]
  before_action :is_authorised, only: [:listing, :pricing, :description, :photo_upload, :amenities, :location, :update, :claim_tasks]

  def index
    @claims = current_user.claims
  end

  def new
    @claim = current_user.claims.build
    @attachments = @claim.attachments
  end

  def create

    @claim = current_user.claims.build(claim_params)
    if @claim.save
      if params[:images]
        params[:images].each do |img|
          @claim.attachments.create(file: img, file_type: 'image')
        end
      end
      redirect_to listing_claim_path(@claim), notice: "Saved..."
    else
      flash[:alert] = "Something went wrong."
      render :new
    end
  end

  def show
    @attachments = @claim.attachments
    @guest_reviews = @claim.guest_reviews
  end

  def listing
    @attachments = @claim.attachments
    @insured_contact = @claim.claim_insured_contact || @claim.contacts.new(type: 'InsuredContact')
    @claimant_contact = @claim.claim_claimant_contact || @claim.contacts.new(type: 'OtherContact')
  end

  def pricing
  end

  def description
  end

  def photo_upload
    @attachments = @claim.attachments
  end

  def claim_tasks
    @claim_tasks = @claim.tasks
  end

  def amenities
  end

  def location
  end

  def lost_details
    @claim = Claim.find(params[:id])
    if @claim.claim_additional_detail.present?
      @claim.claim_additional_detail.update_attributes(claim_additional_params)
    else
      @additional_details = @claim.build_claim_additional_detail(claim_additional_params)
      @additional_details.save
    end
    flash[:success] = "Details updated successfully"
    redirect_to claim_damages_path(@claim)
  end

  def update

    new_params = claim_params
    new_params = claim_params.merge(active: true) if is_ready_claim
    @attachments = @claim.attachments
    if @claim.update(new_params)
      if params[:images]
        params[:images].each do |img|
          @claim.attachments.create(file: img, file_type: 'image')
        end
      end
      @insured_contact =  @claim.claim_insured_contact || @claim.contacts.new(type: 'InsuredContact')# if params[:insured_contact]
      @claimant_contact = @claim.claim_claimant_contact || @claim.contacts.new(type: 'OtherContact')# if params[:other_contact]
      render action: :listing and return false unless update_insured_contact if params[:insured_contact]
      render action: :listing and return false unless update_claimant_contact if params[:other_contact]
      flash[:notice] = "Saved..."
    else
      flash[:alert] = "Something went wrong..."
    end
    render action: :listing  and return false
  end

  def update_insured_contact
    return true if params[:insured_contact][:firstname].blank? && params[:insured_contact][:lastname].blank? && params[:insured_contact][:email].blank?
    if @claim.claim_insured_contact.present?
      @insured_contact = @claim.claim_insured_contact
      unless @insured_contact.update(insured_contact_params)
        flash[:alert] = @insured_contact.errors.full_messages
        return false
      end
      return true
    else
      @insured_contact = @claim.contacts.new(insured_contact_params.merge!(type: 'InsuredContact'))
      if @insured_contact.save
        @claim.claim_contact_mappings << ClaimContactMapping.new(for_claim: true, contact: @insured_contact)
        @claim.claim_additional_detail.present? ? @claim.claim_additional_detail.update_column(:insured_id, @insured_contact.id) : @claim.create_claim_additional_detail(insured_id: @insured_contact.id)
        return true
      else
        flash[:alert] = @insured_contact.errors.full_messages
        return false
      end
    end
  end

  def update_claimant_contact
    return true if params[:other_contact][:firstname].blank? && params[:other_contact][:lastname].blank? && params[:other_contact][:email].blank?
    if @claim.claim_claimant_contact.present?
      @claimant_contact = @claim.claim_claimant_contact
      unless @claimant_contact.update(claimant_contact_params)
        flash[:alert] = @claimant_contact.errors.full_messages
        return false
      end
      return true
    else
      @claimant_contact = @claim.contacts.new(claimant_contact_params.merge!(type: 'OtherContact'))
      if @claimant_contact.save
        @claim.claim_contact_mappings << ClaimContactMapping.new(for_claim: true, contact: @claimant_contact)
        @claim.claim_additional_detail.present? ? @claim.claim_additional_detail.update_column(:claimant_id, @claimant_contact.id) : @claim.create_claim_additional_detail(claimant_id: @claimant_contact.id)
        return true
      else
        flash[:alert] = @claimant_contact.errors.full_messages
        return false
      end
    end
  end

  # --- Reservations ---
  def preload
    today = Date.today
    reservations = @claim.reservations.where("(start_date >= ? OR end_date >= ?) AND status = ?", today, today, 1)
    unavailable_dates = @claim.calendars.where("status = ? AND day > ?", 1, today)

    special_dates = @claim.calendars.where("status = ? AND day > ? AND price <> ?",0, today, @claim.price)

    render json: {
        reservations: reservations,
        unavailable_dates: unavailable_dates,
        special_dates: special_dates
    }
  end

  def preview
    start_date = Date.parse(params[:start_date])
    end_date = Date.parse(params[:end_date])

    output = {
      conflict: is_conflict(start_date, end_date, @claim)
    }

    render json: output
  end


  private
    def is_conflict(start_date, end_date, claim)
      check = claim.reservations.where("(? < start_date AND end_date < ?) AND status = ?", start_date, end_date, 1)
      check_2 = claim.calendars.where("day BETWEEN ? AND ? AND status = ?", start_date, end_date, 1).limit(1)

      check.size > 0 || check_2.size > 0 ? true : false
    end

    def set_claim
      @claim = Claim.find(params[:id])
    end

    def is_authorised
      redirect_to root_path, alert: "You don't have permission" unless current_user.id == @claim.user_id
    end

    def is_ready_claim
      !@claim.active && !@claim.price.blank? && !@claim.listing_name.blank? && !@claim.attachments.blank? && !@claim.address.blank?
    end

    def claim_params
      params.require(:claim).permit(:claim_type, :incident_type, :sub_incident_type, :status, :policy_ref, :claim_reported_date, :claim_loss_date, :claim_reference_carrier, :claim_reference_external, :claim_reference_external_note, :listing_name, :summary, :address, :is_contents, :is_commercial, :price, :active, :instant, :insurer)
    end

    def insured_contact_params
      params.require(:insured_contact).permit(:firstname, :lastname, :email, :mobile, :number, :street, :city, :postcode, :state, :country, :con_type)
    end

    def claimant_contact_params
      params.require(:other_contact).permit(:firstname, :lastname, :email, :mobile, :number, :street, :city, :postcode, :state, :country, :con_type)
    end

    def claim_additional_params
      params.require(:claim_additional_detail).permit(:is_cat, :cat_id, :excess_amount)
    end
  end
