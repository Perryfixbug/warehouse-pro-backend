class Product < ApplicationRecord
  LOW_STOCK_LIMIT = 10
  PRODUCT_PARAMS = %w(name unit price_per_unit quantity detail product_code).freeze

  validates :name, presence: true, uniqueness: { case_sensitive: false },  if: :will_save_change_to_name?
  validates :price_per_unit, presence: true, numericality: { greater_than: 0 }
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :low_stock_count, -> { where("quantity <= ?", LOW_STOCK_LIMIT).count }
  scope :low_stock_product, ->(limit) {where("quantity <= ?", LOW_STOCK_LIMIT).order(:quantity).limit(limit)}
  scope :total_products, -> {sum(:quantity)}
  scope :inventory_value, -> {sum("quantity * price_per_unit")}

  def self.ransackable_attributes(auth_object = nil)
    [
      "name",
      "unit",
      "price_per_unit",
      "created_at"
    ]
  end
end
