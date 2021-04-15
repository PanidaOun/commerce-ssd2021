module Admins
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[ show edit update destroy ]
    before_action :authenticate_admin!, except: [ :show, :index]

    # GET /products or /products.json
    def index
      @search = params[:search]

      @products = Product.all
      @products = @products
        .search(@search) if @search.present?
      @products = @products.page(params[:page]).per(5)

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
          format.html { redirect_to admins_product_path(@product), notice: "Product was successfully created." }
          format.json { render :show, status: :created, location: admins_product_path(@product) }
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
          format.html { redirect_to admins_product_path(@product), notice: "Product was successfully updated." }
          format.json { render :show, status: :ok, location: admins_product_path(@product) }
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
        format.html { redirect_to admins_products_path, notice: "Product was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def csv_upload
      data = params[:csv_file].read.split("\n")
      data.each do |line|
        attr = line.split(",").map(&:strip)
        Product.create title: attr[0], description: attr[1], stock: attr[2]
      end
      redirect_to admins_products_path
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:title, :description, :stock, :status, :primary_image, :remove_primary_image, :remove_supporting_images, :supporting_images=>[], :category_ids=>[])
      end

      def generate_csv(products)
        products.map do |a|
          [a.title, a.description].join(',')
        end.join("\n")
      end
  end
end