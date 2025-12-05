class DashboardController < ApplicationController
  WEEKDAY_MAP = {
    1 => "T2", 2 => "T3", 3 => "T4", 4 => "T5", 
    5 => "T6", 6 => "T7", 7 => "CN"
  }

  def stats
    this_week_orders_count = Order.this_week_orders.count
    last_week_orders_count = Order.last_week_orders.count

    order_change_percent =
      if last_week_orders_count.zero?
        this_week_orders_count.zero? ? 0 : 100
      else
        (((this_week_orders_count - last_week_orders_count).to_f / last_week_orders_count) * 100).round
      end

    is_positive = this_week_orders_count >= last_week_orders_count

    render json: {
      total_products: Product.total_products,
      inventory_value: Product.inventory_value.round,
      low_stock: Product.low_stock_count,
      order: {
        this_week: this_week_orders_count.round,
        change: order_change_percent,
        is_positive: is_positive
      }
    }
  end

  def alerts
    products = Product.low_stock_product(params[:limit] || 50)

    render json: {
      status: "success",
      data: products.as_json(
        only: [:id, :name, :quantity]
      )
    }, status: :ok
  end

  def chart
    start_of_date = 7.days.ago.beginning_of_day
    end_of_date = Time.current.end_of_day
    days = (start_of_date.to_date..end_of_date.to_date).to_a

    import_data = ImportOrder.count_order_in_week
    export_data = ExportOrder.count_order_in_week

    chart_data = days.map do |date|
      {
        date: WEEKDAY_MAP[date.cwday],
        import: import_data[date] || 0,
        export: export_data[date] || 0
      }
    end

    render json: {
      status: "success",
      data: chart_data
    }, status: :ok
  end
end
