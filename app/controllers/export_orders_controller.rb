class ExportOrdersController < OrdersController
  # GET /orders or /orders.json
  def index
    @orders = ExportOrder.includes(:agency, :user).order(created_at: :desc)
  end

  # GET /orders/1 or /orders/1.json
  def show ; end

  # GET /orders/new
  def new
    @order = ExportOrder.new(user: current_user)

    if params[:search_agency]
      @agency = Agency.find_by(id: params[:agency_query]) || Agency.find_by(name: params[:agency_query])
    elsif params[:search_product]
      @products = Product.where("name LIKE ?", "%#{params[:product_query]}%")
    end
  end

  # POST /orders or /orders.json
  def create
    @order = ExportOrder.new(order_params)
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
  def order_params
    # Gộp ordered_products từ params[:order] vào params[:import_order]
    if params[:order].present? && params[:order][:ordered_products_attributes].present?
      params[:export_order] ||= {}
      params[:export_order][:ordered_products_attributes] = params[:order][:ordered_products_attributes]
    end

    params.require(:export_order).permit(
      :agency_id,
      ordered_products_attributes: [:product_id, :quantity, :_destroy]
    )
  end
end