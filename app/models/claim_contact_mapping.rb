class ClaimContactMapping < ApplicationRecord
  belongs_to :claim
  belongs_to :contact
end
