class PhotosController < ApplicationController

  def create
    @claim = Claim.find(params[:claim_id])

    if params[:images]
      params[:images].each do |img|
        @claim.photos.create(image: img)
      end

      @photos = @claim.photos
      redirect_back(fallback_location: request.referer, notice: "Saved...")
    end
  end

  def destroy
    @photo = Photo.find(params[:id])
    @claim = @photo.claim

    @photo.destroy
    @photos = Photo.where(claim_id: @claim.id)

    respond_to :js
  end
end
