class Damage < ApplicationRecord

  has_one :attachment, dependent: :destroy
  has_attached_file :photo, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates_numericality_of :product_cost, :only_integer => false, :allow_nil => true
  validates_numericality_of :labour_cost, :only_integer => false, :allow_nil => true
  validates_presence_of :summary


  def cover_photo(size)
    if self.attachment.present?
      self.attachment.file.url(size)
    else
      "No Image.jpg"
    end
  end

end
