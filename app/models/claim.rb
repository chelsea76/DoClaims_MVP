class Claim < ApplicationRecord
  enum instant: {Request: 0, Instant: 1}

  belongs_to :user
  has_many :photos
  has_many :reservations
  has_many :tasks
  has_many :damages
  has_many :claim_contact_mappings
  has_many :contacts, through: :claim_contact_mappings
  has_one :claim_additional_detail

  has_many :guest_reviews
  has_many :calendars

  has_many :tasks

  geocoded_by :address
  after_validation :geocode, if: :address_changed?

  validates :incident_type, presence: true
  # validates :sub_incident_type, presence: true
  validates :claim_type, presence: true
  # validates :policy_ref, presence: true
  # validates :bed_room, presence: true
  # validates :bath_room, presence: true

  after_create :create_claim_creator_contact

  INSURER_OPTIONS = [["Allianz", 'ALZ'], ['QBE', 'QBE'], ['RACQ', 'RACQ'], ['Suncorp', 'SCP'], ['Zurich', 'ZUR']].freeze

  def cover_photo(size)
    if self.photos.length > 0
      self.photos[0].image.url(size)
    else
      "No Image.jpg"
    end
  end

  def claim_insured_contact
    contacts.where("contacts.type = 'InsuredContact' AND claim_contact_mappings.for_claim = 1").last
  end

  def claim_claimant_contact
    contacts.where("contacts.type = 'OtherContact' AND claim_contact_mappings.for_claim = 1").last
  end

  def average_rating
    guest_reviews.count == 0 ? 0 : guest_reviews.average(:star).round(2).to_i
  end

  def create_claim_creator_contact
    contacts << user.contact
  end
end
