class HomeController < ApplicationController
  def index
    @search = params[:search]
    @products = Product.all
    @products = @products
      .search(@search) if @search.present?
    @products = @products.page(params[:page]).per(4)
  end
end