class StaticPagesController < ApplicationController
  def home
    @page_title = "Trang chủ"
  end

  def stat
    @page_title = "Thống kê kho"
    # ✅ Thống kê tổng quan
    @product_count = Product.count
    @import_this_month = ImportOrder.where("created_at >= ?", 30.days.ago).count
    @export_this_month = ExportOrder.where("created_at >= ?", 30.days.ago).count
    @inventory_value = Product.sum("quantity * price_per_unit")

    # ✅ Biểu đồ nhập - xuất theo ngày (30 ngày gần nhất)
    @import_chart_data = ImportOrder
      .where(created_at: 30.days.ago..Time.now)
      .group("DATE(created_at)")
      .count

    @export_chart_data = ExportOrder
      .where(created_at: 30.days.ago..Time.now)
      .group("DATE(created_at)")
      .count

    # ✅ Sản phẩm sắp hết hàng
    @low_stock_products = Product.where("quantity < 10").order(:quantity)
  end

  def about
    @page_title = "Giới thiệu"
  end

  def help
    @page_title = "Trợ giúp"
  end
end
