class ProductsController < ApplicationController
  before_action :product, only: %i[ show edit update destroy ]

  # GET /products or /products.json
  def index
    products = Product.all.paginate(page: params[:page], per_page: 10)
    render json: {
      status: "success",
      data: products
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
    params.expect(product: [ :name, :unit, :price_per_unit, :quantity, :detail, :product_code ])
  end
end
