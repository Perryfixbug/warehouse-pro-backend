class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false },  if: :will_save_change_to_name?
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  PRODUCT_PARAMS = %w(name unit price_per_unit quantity detail product_code).freeze
end
