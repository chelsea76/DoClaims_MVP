class DamagesController < ApplicationController
  before_action :authenticate_user!
  before_action :find_claim

  def new
    @damage = @claim.damages.build
  end

  def create
    @damage = @claim.damages.build(damage_params)
    if @damage.save
      flash[:success] = "Damage created successfully"
      redirect_to claim_damages_path(@claim)
    else
      flash[:errors] = @damage.errors.full_messages
      render :new
    end
  end

  def edit
    @damage = Damage.find(params[:id])
  end

  def show
    @damage = Damage.find(params[:id])
  end

  def update
    @damage = Damage.find(params[:id])
    if @damage.update_attributes(damage_params)
      flash[:success] = "Damage updated successfully"
      redirect_to claim_damages_path(@claim)
    else
      flash[:errors] = @damage.errors.full_messages
      render :edit
    end
  end

  def index
    @damages = @claim.damages
    @claim_additional_detail = @claim.claim_additional_detail.present? ? @claim.claim_additional_detail : @claim.build_claim_additional_detail
  end

  def destroy
    @damage = Damage.find(params[:id])
    @damage.destroy
    flash[:damage] = "Damage deleted successfully"
    redirect_to claim_damages_path(@claim)
  end

  def photo
    @damage = Damage.find(params[:id])
    send_file Paperclip.io_adapters.for(@damage.photo).path, { filename: @damage.photo_file_name }
  end

  private

  def find_claim
    @claim = Claim.find(params[:claim_id])
  end

  def damage_params
    params.require(:damage).permit(:description, :summary, :damage_type, :sub_type, :product_cost, :labour_cost, :claim_id, :photo)
  end

end
