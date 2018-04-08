class Attachment < ApplicationRecord
  belongs_to :claim, optional: true
  belongs_to :damage, optional: true

  has_attached_file :file#, styles: { medium: "300x300>", thumb: "100x100>" }
  validates_attachment_content_type :file, :content_type => [/\Aimage\/.*\z/, /\Aapplication\/.*\z/, /\Atext\/.*\z/, /\Avideo\/.*\z/]

  TYPE_OPTIONS = [['Document', 'document'], ['Image', 'image'], ['Video', 'video']].freeze
end
