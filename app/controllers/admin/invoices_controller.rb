class Admin::InvoicesController < ApplicationController
  def index
    @invoices = helpers.sortable(Invoice.all, params)
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def update
    invoice = Invoice.find(params[:id])
    invoice.change_status(params[:status]) if params[:status].present?
    redirect_to "/admin/invoices/#{params[:id]}/"
  end
end
