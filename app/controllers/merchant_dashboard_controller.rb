<<<<<<< HEAD
class MerchantDashboardController < ApplicationController

  def show
    @merchant = Merchant.find(params[:merchant_id])
  end
  
  def index
    @merchant = Merchant.find(params[:merchant_id])
=======
branclass MerchantDashboardController < ApplicationController

  # def index
  #   @merchant = Merchant.all(params[:merchant_id])
  # end

  def show
    @merchant = Merchant.find(params[:id])
>>>>>>> main
  end

end
