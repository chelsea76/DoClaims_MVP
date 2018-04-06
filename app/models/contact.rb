class Contact < ApplicationRecord
  EMAIL_REGEXP = /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i

  belongs_to :user, optional: true
  has_many :claim_contact_mappings
  has_many :claims, through: :claim_contact_mappings

  validates_presence_of :firstname, :lastname, :email
  validates_uniqueness_of :email
  validates_format_of :email, :with => EMAIL_REGEXP

  scope :existing_contacts, ->(term, contact_ids) do
    where("email like '%#{term}%' and id not in (#{contact_ids.join(',')})")
  end

  TYPE_OPTIONS = [['Broker', 'BrokerContact'], ['Insurer', 'InsurerContact'], ['Insured', 'InsuredContact'], ['Builder', 'BuilderContact'], ['Other', 'OtherContact']].freeze
  STATE_OPTIONS = [['ACT', 'ACT'], ['NSW', 'NSW'], ['NT', 'NT'], ['QLD', 'QLD'], ['SA', 'SA'], ['VIC', 'VIC'], ['WA', 'WA']].freeze
  COUNTRY_OPTIONS = [['Australia', 'AUS']].freeze
  CONTACT_TYPE_OPTIONS = [['Individual', 'IND'], ['Business', 'BUS']].freeze
end
