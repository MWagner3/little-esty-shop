class Invoice < ApplicationRecord
  belongs_to :customer

  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :transactions
  enum status: {:in_progress => 0, :completed => 1, :cancelled => 2}

  validates_presence_of :customer_id

  def creation_date_formatted
    created_at.strftime("%A, %B %d, %Y")
  end

  def revenue
    invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def revenue_formatted
    x = invoice_items.sum('invoice_items.quantity * invoice_items.unit_price')/100
    "$#{x.round(2)}"
  end
end
