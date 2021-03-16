class HomeController < ApplicationController
  def index
    @search = params[:search]

    @products = Product.all
    @products = @products
      .where("title LIKE ? or description LIKE ?", "%#{@search}%", "%#{@search}%") if @search.present?
    @products = @products.page(params[:page]).per(5)
  end
end