class BulkDiscountsController < ApplicationController
    def index 
       @merchant = Merchant.find(params[:merchant_id])
       @discounts = @merchant.bulk_discounts 
    end

    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create 
        merchant = Merchant.find(params[:merchant_id])
        merchant.bulk_discounts.create(bulk_discount_params)

        redirect_to("/merchants/#{merchant.id}/bulk_discounts", notice: "Discount Added")
    end

    def show
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.find(params[:id])
    end

    def destroy
        merchant = Merchant.find(params[:merchant_id])
        BulkDiscount.find(params[:id]).destroy
        redirect_to("/merchants/#{merchant.id}/bulk_discounts", notice: "Discount Removed")
    end
    private 
    def bulk_discount_params
        params.permit(:name, :discount, :quantity)
    end
end