class OrdersController < ApplicationController
  # GET /orders or /orders.json
  def index
    order_all = Order
                .left_joins(:agency)
                .includes(:user, ordered_products: :product)
                .order(created_at: :desc)
    orders = Search::OrderSearch.new(params, order_all).call
    p orders
    render json: {
      status: "success",
      data: orders.as_json(include: [
          :agency, :user, 
          ordered_products: {
            include: :product  
          }
      ], methods: [:type, :total_price] )
    }, status: :ok
  end

  # POST /orders or /orders.json
  def create
    order = Order.new(order_params.merge(user: current_user))

    # Gán giá cho từng OrderedProduct trước khi lưu
    order.ordered_products.each do |op|
      product = Product.find_by(id: op.product_id)
      op.price_per_unit = product.price_per_unit if product.present?
    end

    if order.save
      render json: {
        status: "success",
        data: order.as_json(include: [
            :agency, :user, 
            ordered_products: {
              include: :product  
            }
        ], methods: [:type, :total_price] )
      }, status: :created
    else
      render json: {
        status: "error",
        error: order.errors
      }, status: :unprocessable_entity
    end
  end

  def destroy
    if order.destroy
      render json: {
        status: "success",
        data: "Delete successfully! "
      }, status: :ok
    else
      render json: {
        status: "error",
        error: order.errors
      }, status: :unprocessable_entity
    end
  end

  def order
    @_order = Order.find(params[:id])
  end
  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(
      :type,
      :agency_id,
      ordered_products_attributes: [ :product_id, :quantity, :_destroy ]
    )
  end
end
