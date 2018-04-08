module ApplicationHelper
  def avatar_url(user)

    if user.image
      "http://graph.facebook.com/#{user.uid}/picture?type=large"
    else
      # gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      # "https://www.gravatar.com/avatar/#{gravatar_id}.jpg?d=identical&s=150"
      "http://icons.iconarchive.com/icons/3xhumed/mega-games-pack-36/256/Avatar-3-icon.png"
    end
  end

  def stripe_express_path
    "https://connect.stripe.com/express/oauth/authorize?response_type=code&client_id=ca_Bdg4YHC3aw16NZnFRc093I1x2ZYcHMeS&scope=read_write"
  end

  def attachment_url(damage)
    if damage.attachment.present?
      if damage.attachment.file_type == 'image'
        image_tag damage.attachment.file.url(), style: 'width:100%'
      elsif damage.attachment.file_type == 'document'
        link_to damage.attachment.file_file_name, photo_claim_damage_path(claim_id: @claim.id, id: damage.id), style: 'word-wrap: break-word;'
      elsif damage.attachment.file_type == 'video'
        video_tag damage.attachment.file.url, size: "140x100", :controls => true
      end
    else
      image_tag 'No Image.jpg', style: 'width:100%'
    end
  end
end
