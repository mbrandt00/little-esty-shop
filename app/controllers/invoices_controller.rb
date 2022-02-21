class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
    @merchant = Merchant.find(params[:id])
  end

  def show
    @invoice = Invoice.find(params[:id])
    # require "pry"; binding.pry
  end
end
