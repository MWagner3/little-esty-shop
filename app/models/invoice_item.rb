class InvoiceItem < ApplicationRecord
  belongs_to :item
  belongs_to :invoice
  has_many :merchants, through: :items
  has_many :transactions, through: :invoice

  validates :quantity, presence: true
  validates :unit_price, presence: true
  validates :invoice_id, presence: true
  validates :item_id, presence: true

  enum status: {:pending => 0, :packaged => 1, :shipped => 2} #used in the InvoiceItems Controller, Status action
end
