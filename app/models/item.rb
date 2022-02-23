class Item < ApplicationRecord
  belongs_to :merchant

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  has_many :transactions, through: :invoices

  validates :name, presence: true
  validates :description, presence: true
  validates :unit_price, presence: true
  enum status: { enabled: 0, disabled: 1 }

  def self.enabled_items
    where(status: 0)
  end

  def self.disabled_items
    where(status: 1)
  end
end
