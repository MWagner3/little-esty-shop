class MerchantsController < ApplicationController
  # def dashboard
  #   @merchant = Merchant.find(params[:id])
  # end

  def show
    @merchant = Merchant.find(params[:id])
  end
end
