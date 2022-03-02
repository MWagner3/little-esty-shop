class MerchantDashboardController < ApplicationController

  # def index
  #   @merchant = Merchant.all(params[:merchant_id])
  # end

  def show
    @merchant = Merchant.find(params[:id])
  end

end
