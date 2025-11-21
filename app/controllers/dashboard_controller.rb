class DashboardController < ApplicationController
  
  def stats
    total_products = Product.sum(:quantity)
    inventory_value = Product.sum("quantity * price_per_unit")
    low_stock = Product.where("quantity <= 10").count

    today_imports = ImportOrder.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).count
    today_exports = ExportOrder.where(created_at: Time.current.beginning_of_day..Time.current.end_of_day).count

    render json: [
      {
        title: "Tổng Tồn Kho",
        value: total_products,
        unit: "sản phẩm",
        change: "+0%",   
        isPositive: true,
        icon: "Package"
      },
      {
        title: "Giá trị Kho",
        value: inventory_value,
        unit: "VNĐ",
        change: "+0%",
        isPositive: true,
        icon: "TrendingUp"
      },
      {
        title: "Hàng Gần Hết",
        value: low_stock,
        unit: "sản phẩm",
        change: "-0%",
        isPositive: low_stock < 20,
        icon: "AlertTriangle"
      },
      {
        title: "Nhập/Xuất Hôm nay",
        value: today_imports + today_exports,
        unit: "đơn vị",
        change: "+0%",
        isPositive: true,
        icon: "TrendingDown"
      }
    ]
  end

  def alerts
    products = Product.where("quantity <= ?", 10)
                      .order(:quantity)
                      .limit(params[:limit] || 50)

    render json: products.as_json(
      only: [:id, :name, :quantity]
    )
  end

  def chart
    import_data = ImportOrder
      .where(created_at: 30.days.ago..Time.current)
      .group("DATE(created_at)")
      .sum(:total_quantity)

    export_data = ExportOrder
      .where(created_at: 30.days.ago..Time.current)
      .group("DATE(created_at)")
      .sum(:total_quantity)

    render json: {
      imports: import_data,
      exports: export_data
    }
  end

  def product_list
    products = Product.order(quantity: :desc)

    render json: products.as_json(
      only: [:id, :name, :quantity, :price_per_unit]
    )
  end
end
