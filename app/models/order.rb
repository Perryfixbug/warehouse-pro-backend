class Order < ApplicationRecord
  belongs_to :user
  belongs_to :agency, optional: true
  has_many :ordered_products, dependent: :destroy
  accepts_nested_attributes_for :ordered_products, allow_destroy: true

  validates :user, presence: true
  validates :agency, presence: true
  validates :type, presence: true, inclusion: { in: %w[ImportOrder ExportOrder] }
  validate :must_have_at_least_one_product

  scope :count_order_in_range, -> (range) {where(created_at: range)
    .group("DATE(created_at)")
    .count
  }
  scope :this_week_orders, -> { where(created_at: this_week_range) }
  scope :last_week_orders, -> { where(created_at: last_week_range) }

  self.inheritance_column = :_type_disabled

  def total_price
    ordered_products.to_a.sum { |op| op.quantity.to_f * op.price_per_unit.to_f }
  end

  class << self
    def count_order_in_week
      start_of_date = 7.days.ago.beginning_of_day
      end_of_date = Time.current.end_of_day
      range = start_of_date..end_of_date

      count_order_in_range(range)
          .transform_keys { |k| Date.parse(k.to_s) }
    end

    def this_week_range
      start = Time.current.beginning_of_week(:monday)
      start..Time.current
    end

    def last_week_range
      this_week_start = Time.current.beginning_of_week(:monday)
      last_week_start = this_week_start - 1.week
      last_week_end   = this_week_start - 1.second
      last_week_start..last_week_end
    end

    def ransackable_attributes(auth_object = nil)
      %w[
        id
        agency_id
        user_id
        type
        created_at
        updated_at
      ].freeze
    end

    def ransackable_associations(auth_object = nil)
      %w[
        agency
        user
        ordered_products
      ].freeze
    end
  end

  private
  def must_have_at_least_one_product
    errors.add(:base, "Đơn hàng phải có ít nhất một sản phẩm") if ordered_products.empty?
  end
end
