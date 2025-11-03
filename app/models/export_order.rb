class ExportOrder < Order
  after_create :update_quantity!

  private
  def update_quantity!
    ordered_products.each do |od|
      product = od.product

      if od.quantity > product.quantity
        raise ActiveRecord::Rollback, "Không đủ số lượng trong kho cho #{product.name}"
      end

      # Cập nhật tồn kho
      product.update!(quantity: product.quantity - od.quantity)
    end
  end
end
