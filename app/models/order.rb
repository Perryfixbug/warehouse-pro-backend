class Order < ApplicationRecord
  belongs_to :user
  belongs_to :agency, optional: true
  has_many :ordered_products, dependent: :destroy
  accepts_nested_attributes_for :ordered_products, allow_destroy: true

  validates :user, presence: true
  validates :agency, presence: true
  validates :type, presence: true, inclusion: { in: %w[ImportOrder ExportOrder] }
  validate :must_have_at_least_one_product

  def total_price
    ordered_products.to_a.sum { |op| op.quantity.to_f * op.price_per_unit.to_f }
  end

  private
  def must_have_at_least_one_product
    errors.add(:base, "Đơn hàng phải có ít nhất một sản phẩm") if ordered_products.empty?
  end
end
