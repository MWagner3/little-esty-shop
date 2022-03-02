class InvoiceItemsController < ApplicationController
  def update
    invoice_item = InvoiceItem.find(params[:id])
    invoice_item.update!(invoice_item_params)

    redirect_to merchant_invoice_path(invoice_item.item.merchant.id, invoice_item.invoice_id)
  end
end
