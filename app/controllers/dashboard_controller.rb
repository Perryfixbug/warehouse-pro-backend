class DashboardController < ApplicationController
  WEEKDAY_MAP = {
    1 => "T2", 2 => "T3", 3 => "T4", 4 => "T5", 
    5 => "T6", 6 => "T7", 7 => "CN"
  }

  def stats
    this_week_start = Time.current.beginning_of_week(:monday)

    last_week_start = this_week_start - 1.week
    last_week_end   = this_week_start - 1.second

    this_week_orders = Order.where(created_at: this_week_start..Time.current).count
    last_week_orders = Order.where(created_at: last_week_start..last_week_end).count

    order_change_percent =
      if last_week_orders.zero?
        this_week_orders.zero? ? 0 : 100
      else
        (((this_week_orders - last_week_orders).to_f / last_week_orders) * 100).round
      end

    is_positive = this_week_orders >= last_week_orders

    render json: {
      total_products: Product.total_products,
      inventory_value: Product.inventory_value.round,
      low_stock: Product.low_stock,
      order: {
        this_week: this_week_orders.round,
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
