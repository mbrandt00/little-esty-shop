class BulkDiscountsController < ApplicationController
    def new

    end
    def index 
       @merchant = Merchant.find(params[:merchant_id])
       @discounts = @merchant.bulk_discounts
    end
end