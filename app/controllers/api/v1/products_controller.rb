class Api::V1::ProductsController < ApplicationController
  respond_to :json

  before_action :authenticate_with_token!, only: [:create, :update, :destroy]

  def index
    products = params[:product_ids].present? ? Product.find(params[:product_ids]) : Product.all
    products = Kaminari.paginate_array(products.to_a).page(params[:page]).per(params[:per_page])

    render json: products, meta: pagination(products, params[:per_page])
  end

  def show
    respond_with Product.find(params[:id])
  end

  def create
    product = current_user.products.build(product_params)
    # since product_params contains a user_id, it's not necessary to build it through the user
    # assoc, but the author suggested that this way is more descriptive

    if product.save
      render json: product, status: 201, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def update
    product = current_user.products.find(params[:id])

    if product.update(product_params)
      render json: product, status: 200, location: [:api, product]
    else
      render json: { errors: product.errors }, status: 422
    end
  end

  def destroy
    product = current_user.products.find(params[:id])
    product.destroy
    head 204
  end

  private

    def product_params
      params.require(:product).permit(:title, :price, :published)
    end

end
