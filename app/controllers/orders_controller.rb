class OrdersController < ApplicationController
  include SessionsHelper
  before_action :set_order, only: %i[ show ]
  before_action :set_agencies, only: [ :new, :create ]
  before_action :set_products, only: [ :new, :create ]

  # GET /orders or /orders.json
  def index
    @orders = Order.includes(:agency, :user).order(created_at: :desc).page(params[:page]).per(10)
  end

  # GET /orders/1 or /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    @order = Order.new(user: current_user)

    if params[:search_agency]
      @agency = Agency.find_by(id: params[:agency_query]) || Agency.find_by(name: params[:agency_query])
    elsif params[:search_product]
      @products = Product.where("name LIKE ?", "%#{params[:product_query]}%")
    end
  end

  # POST /orders or /orders.json
  def create
    @order = Order.new(order_params)
    @order.user = current_user  # gắn user hiện tại

    # Gán giá cho từng OrderedProduct trước khi lưu
    @order.ordered_products.each do |op|
      product = Product.find_by(id: op.product_id)
      op.price_per_unit = product.price_per_unit if product.present?
    end

    if @order.save
      redirect_to @order, notice: "Tạo đơn hàng thành công!"
    else
      flash.now[:alert] = "Không thể tạo đơn hàng, vui lòng kiểm tra lại."
      render :new, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_order
    @order = Order.find(params.expect(:id))
  end

  def set_agencies
    @agencies = Agency.all
  end

  def set_products
    @products = Product.all
  end

  # Only allow a list of trusted parameters through.
  def order_params
    params.require(:order).permit(
      :agency_id,
      ordered_products_attributes: [ :product_id, :quantity, :_destroy ]
    )
  end
end
