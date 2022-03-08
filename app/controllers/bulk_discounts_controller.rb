class BulkDiscountsController < ApplicationController
    def index 
       @merchant = Merchant.find(params[:merchant_id])
       @discounts = @merchant.bulk_discounts 
    end

    def new
        @discount = BulkDiscount.new
        @discount = BulkDiscount.new(discount: 30,
                                     name: 'discount',
                                     threshold: 2,
                                     date: params[:date]) if params[:date].present?
    end

    def create 
        merchant = Merchant.find(params[:merchant_id])
        merchant.bulk_discounts.create(bulk_discount_params)
        redirect_to("/merchants/#{merchant.id}/bulk_discounts", notice: "Discount Added")   
    end

    def edit
        @discount = BulkDiscount.find(params[:id])
    end

    def show
        @merchant = Merchant.find(params[:merchant_id])
        @discount = BulkDiscount.find(params[:id])
        rescue ActiveRecord::RecordNotFound
        flash[:notice] = "The merchant has deleted that discount."
        redirect_to action: :index
    end

    def update
        bulk_discount = BulkDiscount.find(params[:id])
        bulk_discount.update(bulk_discount_params)
        redirect_to(merchant_bulk_discount_path(bulk_discount.merchant, bulk_discount), notice: "Discount Updated")
    end

    def destroy
        merchant = Merchant.find(params[:merchant_id])
        BulkDiscount.find(params[:id]).destroy
        redirect_to("/merchants/#{merchant.id}/bulk_discounts", notice: "Discount Removed")
    end
    private 
    def bulk_discount_params
        params.require(:bulk_discount).permit(:name, :discount, :threshold, :date)
    end
end