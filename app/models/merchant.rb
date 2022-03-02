class Merchant < ApplicationRecord
  enum status: { disabled: 0, enabled: 1 }, _prefix: true

  has_many :items
  has_many :invoice_items, through: :items
  has_many :customers, through: :invoices
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true

  def self.disabled
    where(status: 0)
  end

  def self.enabled
    where(status: 1)
  end

  def top_five_items
    items.joins(invoice_items: { invoice: :transactions })
         .where(transactions: { result: 'success' })
         .select('items.*, SUM(invoice_items.quantity * invoice_items.unit_price)as total_sales')
         .group(:id)
         .order(total_sales: :desc)
         .limit(5)
  end

  def self.top_five_merchants
    joins(invoices: :transactions)
    .where(transactions: { result: 'success' })
    .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue')
    .group(:id)
    .order(total_revenue: :desc)
    .limit(5)
  end

  def total_revenue
    invoice_items.joins(:transactions)
                 .where(transactions: { result: 'success' })
                 .sum('invoice_items.quantity * invoice_items.unit_price')
  end

  def best_selling_day
    binding.pry
  end
end
