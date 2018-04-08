class PhotosController < ApplicationController

  def destroy
    @photo = Attachment.find(params[:id])
    @claim = @photo.claim

    @photo.destroy
    @attachments = Attachment.where(claim_id: @claim.id)

    respond_to :js
  end
end
