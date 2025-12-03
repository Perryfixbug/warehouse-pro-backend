class DashboardController < ApplicationController
  def stats
    total_products = Product.sum(:quantity)
    inventory_value = Product.sum("quantity * price_per_unit")
    low_stock = Product.where("quantity <= 10").count

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
      total_products: total_products,
      inventory_value: inventory_value.round,
      low_stock: low_stock,
      order: {
        this_week: this_week_orders.round,
        change: order_change_percent,
        is_positive: is_positive
      }
    }
  end

  def alerts
    products = Product.where("quantity <= ?", 10)
                      .order(:quantity)
                      .limit(params[:limit] || 50)

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

    range = start_of_date..end_of_date

    import_data = ImportOrder
                    .where(created_at: range)
                    .group("DATE(created_at)")
                    .count
                    .transform_keys { |k| Date.parse(k.to_s) }

    export_data = ExportOrder
                    .where(created_at: range)
                    .group("DATE(created_at)")
                    .count
                    .transform_keys { |k| Date.parse(k.to_s) }

    weekday_map = {
      1 => "T2", 2 => "T3", 3 => "T4", 4 => "T5", 
      5 => "T6", 6 => "T7", 7 => "CN"
    }

    chart_data = days.map do |date|
      {
        date: weekday_map[date.cwday],
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
