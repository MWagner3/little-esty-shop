class MerchantDashboardController < ApplicationController

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

end
