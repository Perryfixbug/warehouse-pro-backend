class ProductsController < ApplicationController
  before_action :product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    products = Search::ProductSearch.new(params, Product.all).call
    products_per_page = products.paginate(page: params[:page] || 1, per_page: 10)
    render json: {
      status: "success",
      data: products_per_page,
      meta: {
        current_page: products_per_page.current_page,
        total_pages: products_per_page.total_pages
      }
    }, status: :ok
  end

  # GET /products/1 or /products/1.json
  def show
    if product
      render json: {
        status: "success",
        data: product
      }, status: :ok
    else
      render json: {
        status: "error"
      }, status: :not_found
    end
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products or /products.json
  def create
    product = Product.new(product_params)
    if product.save
      render json: {
        status: "success",
        data: product
      }, status: :created
    else
      render json: {
        status: "error",
        error: product.errors
      }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    if product.update(product_params)
      render json: {
        status: "success",
        data: product
      }, status: :ok
    else
      render json: {
        status: "error",
        error: product.errors
      }, status: :unprocessable_entity
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    if product.destroy
      render json: {
        status: "success",
        data: "Delete successfully! "
      }, status: :ok
    else
      render json: {
        status: "error",
        error: product.errors
      }, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def product
    @_product = Product.find( params[:id] )
  end

  # Only allow a list of trusted parameters through.
  def product_params
    params.require(:product).permit(Product::PRODUCT_PARAMS)
  end
end
