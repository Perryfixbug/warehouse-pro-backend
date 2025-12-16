class Agency < ApplicationRecord
  has_many :orders

  class << self
    def ransackable_attributes(auth_object = nil)
      %w[
        id
        name
        email
        phone
        location
        created_at
        updated_at
      ]
    end
  end
end
