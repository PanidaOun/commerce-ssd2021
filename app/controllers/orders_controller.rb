class OrdersController < ApplicationController
    before_action :authenticate_admin!, only: [:index]
    def index
        @orders = Order.all
    end

    def show
        @order = Order.find(params[:id])
        @product = Product.find(@order.product_id)
    end
    
    def new
        @order = Order.new
        @product = Product.find(params[:id].to_i)
        @product_id = params[:id].to_i
    end

    def create
        @order = Order.new(order_params)

        if @order.save
            redirect_to @order
        else
            render :new
        end
    end

    private
        def order_params
            params.require(:order).permit(:product_id, :address)
        end
end

