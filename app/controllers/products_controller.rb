class ProductsController < ApplicationController
  before_action :set_product, only: %i[ show edit update destroy ]
  before_action :authenticate_admin!, except: [:index, :show]
  # GET /products or /products.json
  def index
    @products = Product.all
    respond_to do |format|
      format.html
      format.csv{ send_data generate_csv(Product.all), file_name: 'products.csv' }
    end
  end

  # GET /products/1 or /products/1.json
  def show
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
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1 or /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: "Product was successfully updated." }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1 or /products/1.json
  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def csv_upload
    data = params[:csv_file].read.split("\n")
    data.each do |line|
      attr = line.split(",").map(&:strip)
      Product.create title: attr[0], description: attr[1], stock: attr[2]
    end
    redirect_to root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def product_params
      params.require(:product).permit(:title, :description, :stock, :status, :category_ids=>[])
    end

    def generate_csv(products)
      products.map do |a|
        [a.title, a.description].join(',')
      end.join("\n")
    end
end
