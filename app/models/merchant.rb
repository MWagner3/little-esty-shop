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

  def top_five_customers
    customers.joins(:invoices, :transactions)
              .where('transactions.result = ?', 1)
              .select('customers.*, count(*) AS transaction_count')
              .group('customers.id')
              .order('transaction_count DESC')
              .limit(5)
  end


  # commented out by LT --- this is not working - we may need more of the project written? I'll come back to this.
  # def self.top_five_merchants
  #   joins(invoices: :transactions)
  #   .where('transactions.result = ?', 'success') --- try it this way? (transactions: { result: 'success' }) --SI
  #   .select('merchants.*, sum(invoice_items.unit_price * invoice_items.quantity) as total_revenue')
  #   .group(:id)
  #   .order(total_revenue: :desc)
  #   .limit(5)
  # end
end
