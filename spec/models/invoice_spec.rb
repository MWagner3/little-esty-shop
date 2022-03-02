require 'rails_helper'

RSpec.describe Invoice do
  describe 'relations' do
    it { should belong_to :customer }
    it { should have_many :transactions}
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:customer_id)}
    it { should define_enum_for(:status).with({:in_progress => 0, :completed => 1, :cancelled => 2}) }
  end

  describe 'instance methods' do
    describe '#creation_date_formatted' do
      it 'date is fomatted as DAY, MM DD, YYYY' do
        customer_1 = Customer.create!(first_name: 'Paul', last_name: 'Atreides')
        invoice_1 = customer_1.invoices.create!(status: 1, created_at: '2022-02-25 10:01:05')
        expect(invoice_1.creation_date_formatted).to eq('Friday, February 25, 2022')
      end
    end

    describe '#revenue' do
      it 'generates revenue ' do
        customer_1 = Customer.create!(first_name: 'Paul', last_name: 'Atreides')
        invoice_1 = customer_1.invoices.create!(status: 1, created_at: '2022-02-25 10:01:05')
        invoice_2 = customer_1.invoices.create!(status: 1, created_at: '2022-02-25 10:01:05')
        merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC", status: 0)

        item_1 = merchant_1.items.create!(name: "Green Shirt", description: "A shirt what's green", unit_price: 25)
        item_2 = merchant_1.items.create!(name: "Red Shirt", description: "A shirt what's red", unit_price: 25)
        item_3 = merchant_1.items.create!(name: "Blue Shirt", description: "A shirt what's blue", unit_price: 25)
        item_4 = merchant_1.items.create!(name: "Bluey Shirt", description: "A shirt what's blue", unit_price: 25)

        invoice_item_1 = InvoiceItem.create!(item_id: item_1.id, invoice_id: invoice_1.id, unit_price: 25, quantity: 5, status: 0)
        invoice_item_2 = InvoiceItem.create!(item_id: item_2.id, invoice_id: invoice_1.id, unit_price: 25, quantity: 2, status: 0)
        invoice_item_3 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_1.id, unit_price: 25, quantity: 2, status: 0)
        invoice_item_4 = InvoiceItem.create!(item_id: item_3.id, invoice_id: invoice_2.id, unit_price: 25, quantity: 2, status: 0)

        expect(invoice_1.revenue).to eq(225)
      end
    end
  end
end
