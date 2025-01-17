require 'rails_helper'

RSpec.describe Merchant do
  describe 'relations' do
    it { should have_many(:items) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
  end

  describe 'class methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC", status: 0)
      @merchant_2 = Merchant.create!(name: 'Handmade in CO Co.', status: 1)
      @merchant_3 = Merchant.create!(name: 'Happy Crafts', status: 1)
      @merchant_4 = Merchant.create!(name: 'Oddities')
      @merchant_5 = Merchant.create!(name: 'Rip Off Tshirts', status: 1)

      @item_1 = @merchant_5.items.create!(name: "Green Shirt", description: "A shirt what's green", unit_price: 25)
      @item_2 = @merchant_1.items.create!(name: "Red Shirt", description: "A shirt what's red", unit_price: 25)
      @item_3 = @merchant_1.items.create!(name: "Blue Shirt", description: "A shirt what's blue", unit_price: 25)
      @item_4 = @merchant_2.items.create!(name: "CO Flag Art", description: "Sculpture", unit_price: 1000)
      @item_5 = @merchant_2.items.create!(name: "John Denver Portrait", description: "Painting", unit_price: 3000)
      @item_6 = @merchant_3.items.create!(name: "Craft 1", description: "It's crafty", unit_price: 20)
      @item_7 = @merchant_4.items.create!(name: "Nothing but Belts", description: "A belt", unit_price: 50)

      @customer_1 = Customer.create!(first_name: "Paul", last_name: "Atreides")
      @customer_2 = Customer.create!(first_name: "Baron", last_name: "Harkonnen")
      @customer_3 = Customer.create!(first_name: "Reverend", last_name: "Mother")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
      @invoice_2 = @customer_2.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')
      @invoice_3 = @customer_3.invoices.create!(status: 1, created_at: '2012-03-25 09:54:09')

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 5, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_2.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_2.id, unit_price: 1000, quantity: 1, status: 0)
      @invoice_item_5 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)
      @invoice_item_6 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)
      @invoice_item_7 = InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)

      @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 4654405418249632, result: 'success')
      @transaction_1 = @invoice_2.transactions.create!(credit_card_number: 4654405418249633, result: 'success')
      @transaction_1 = @invoice_3.transactions.create!(credit_card_number: 4654405418249633, result: 'success')

    end

    it 'returns all merchants with a status of disabled' do
      expect(Merchant.disabled).to eq([@merchant_1, @merchant_4])
    end

    it 'returns all merchants with a status of enabled' do
      expect(Merchant.enabled).to eq([@merchant_2, @merchant_3, @merchant_5])
    end

    it 'lists the top five merchants ordered by total revenue' do

      expect(Merchant.top_five_merchants.first).to eq(@merchant_2)
      expect(Merchant.top_five_merchants.second).to eq(@merchant_3)
      expect(Merchant.top_five_merchants.third).to eq(@merchant_4)
      expect(Merchant.top_five_merchants.fourth).to eq(@merchant_5)
      expect(Merchant.top_five_merchants.last).to eq(@merchant_1)
    end
  end

  describe 'instance methods' do
    before :each do
      @merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC", status: 0)
      @merchant_2 = Merchant.create!(name: 'Handmade in CO Co.', status: 1)
      @merchant_3 = Merchant.create!(name: 'Happy Crafts', status: 1)
      @merchant_4 = Merchant.create!(name: 'Oddities')
      @merchant_5 = Merchant.create!(name: 'Rip Off Tshirts', status: 1)

      @item_1 = @merchant_5.items.create!(name: "Green Shirt", description: "A shirt what's green", unit_price: 25)
      @item_2 = @merchant_1.items.create!(name: "Red Shirt", description: "A shirt what's red", unit_price: 25)
      @item_3 = @merchant_1.items.create!(name: "Blue Shirt", description: "A shirt what's blue", unit_price: 25)
      @item_4 = @merchant_2.items.create!(name: "CO Flag Art", description: "Sculpture", unit_price: 1000)
      @item_5 = @merchant_2.items.create!(name: "John Denver Portrait", description: "Painting", unit_price: 3000)
      @item_6 = @merchant_3.items.create!(name: "Craft 1", description: "It's crafty", unit_price: 20)
      @item_7 = @merchant_4.items.create!(name: "Nothing but Belts", description: "A belt", unit_price: 50)
      @item_8 = @merchant_1.items.create!(name: "Pink Shirt", description: "A shirt what's pink", unit_price: 25)
      @item_9 = @merchant_1.items.create!(name: "Purple Shirt", description: "A shirt what's purple", unit_price: 25)
      @item_10 = @merchant_1.items.create!(name: "Yellow Shirt", description: "A shirt what's yellow", unit_price: 25)

      @customer_1 = Customer.create!(first_name: "Paul", last_name: "Atreides")
      @customer_2 = Customer.create!(first_name: "Baron", last_name: "Harkonnen")
      @customer_3 = Customer.create!(first_name: "Reverend", last_name: "Mother")

      @invoice_1 = @customer_1.invoices.create!(status: 1, created_at: '2022-03-25 09:54:09')
      @invoice_2 = @customer_2.invoices.create!(status: 1, created_at: '2022-03-25 09:54:09')
      @invoice_3 = @customer_3.invoices.create!(status: 1, created_at: '2022-03-25 09:54:09')
      @invoice_4 = @customer_3.invoices.create!(status: 1, created_at: '2022-03-25 09:54:09')

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 6, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 3, status: 0)
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_2.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_4 = InvoiceItem.create!(item_id: @item_4.id, invoice_id: @invoice_2.id, unit_price: 1000, quantity: 1, status: 0)
      @invoice_item_5 = InvoiceItem.create!(item_id: @item_5.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)
      @invoice_item_6 = InvoiceItem.create!(item_id: @item_6.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)
      @invoice_item_7 = InvoiceItem.create!(item_id: @item_7.id, invoice_id: @invoice_3.id, unit_price: 3000, quantity: 1, status: 0)
      @invoice_item_8 = InvoiceItem.create!(item_id: @item_8.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_9 = InvoiceItem.create!(item_id: @item_9.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_10 = InvoiceItem.create!(item_id: @item_10.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_11 = InvoiceItem.create!(item_id: @item_8.id, invoice_id: @invoice_4.id, unit_price: 25, quantity: 1, status: 0)

      @transaction_1 = @invoice_1.transactions.create!(credit_card_number: 4654405418249632, result: 'success')
      @transaction_1 = @invoice_2.transactions.create!(credit_card_number: 4654405418249633, result: 'sucess')
      @transaction_1 = @invoice_3.transactions.create!(credit_card_number: 4654405418249633, result: 'success')
      @transaction_4 = @invoice_4.transactions.create!(credit_card_number: 4654405418249633, result: 'failed')

    end

    it 'list the top five items for that merchant' do
      expect(@merchant_1.top_five_items).to eq([@item_2, @item_3, @item_8, @item_9, @item_10])
    end

    it 'lists total revenue for merchant' do
      expect(@merchant_1.total_revenue).to eq(375)
    end

    it 'lists best_selling_day for merchant' do
      expect(@merchant_1.best_selling_day).to eq("Friday, March 25, 2022")
    end
  end
end
