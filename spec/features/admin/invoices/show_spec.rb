require 'rails_helper'

RSpec.describe 'Admin Invoices Show' do
  describe 'user story #8 / #6 / #5' do
    before :each do
      @customer_1 = Customer.create!(first_name: "Paul", last_name: "Atreides")
      @customer_2 = Customer.create!(first_name: "Baron", last_name: "Harkonnen")
      @customer_3 = Customer.create!(first_name: "Reverend", last_name: "Mother")

      @invoice_1 = @customer_1.invoices.create!(created_at: '2012-03-25 09:54:09', status: 1)

      @merchant_1 = Merchant.create!(name: "LT's Tee Shirts LLC", status: 0)

      @item_1 = @merchant_1.items.create!(name: "Green Shirt", description: "A shirt what's green", unit_price: 25)
      @item_2 = @merchant_1.items.create!(name: "Red Shirt", description: "A shirt what's red", unit_price: 25)
      @item_3 = @merchant_1.items.create!(name: "Blue Shirt", description: "A shirt what's blue", unit_price: 25)

      @invoice_item_1 = InvoiceItem.create!(item_id: @item_1.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 5, status: 0)
      @invoice_item_2 = InvoiceItem.create!(item_id: @item_2.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)
      @invoice_item_3 = InvoiceItem.create!(item_id: @item_3.id, invoice_id: @invoice_1.id, unit_price: 25, quantity: 2, status: 0)

      visit admin_invoice_path(@invoice_1.id)
    end

    it "when visiting /admin/invoices/:id admin sees invoice attributes" do

      expect(page).to have_content(@invoice_1.id)
      expect(page).to have_content(@invoice_1.status)
      expect(page).to have_content(@invoice_1.creation_date_formatted)
      expect(page).to have_content(@customer_1.first_name)
      expect(page).to have_content(@customer_1.last_name)
    end

    it "when visiting /admin/invoices/:id admin sees item info" do
      within("#item-#{@item_1.id}") do
        expect(page).to have_content(@item_1.name)
        expect(page).to have_content(@invoice_item_1.quantity)
        expect(page).to have_content(@invoice_item_1.unit_price)
        expect(page).to have_content(@invoice_item_1.status)
      end

      within("#item-#{@item_2.id}") do
        expect(page).to have_content(@item_2.name)
        expect(page).to have_content(@invoice_item_2.quantity)
        expect(page).to have_content(@invoice_item_2.unit_price)
        expect(page).to have_content(@invoice_item_2.status)
      end

      within("#item-#{@item_3.id}") do
        expect(page).to have_content(@item_3.name)
        expect(page).to have_content(@invoice_item_3.quantity)
        expect(page).to have_content(@invoice_item_3.unit_price)
        expect(page).to have_content(@invoice_item_3.status)
      end
    end

    it "when visiting /admin/invoices/:id see revenue generated from invoice" do
      expect(page).to have_content("Total Revenue: $#{@invoice_1.revenue}")
    end

    it "when visiting /admin/invoices/:id see status is a select field - showing current status" do
      expect(page).to have_content("Total Revenue: $#{@invoice_1.revenue}")
      expect(page).to have_field('status', with: 'completed')
      expect(page).to have_button('Update Invoice Status')
    end

    it 'new status can be selected and updated by clicking submit button' do
      expect(page).to have_field('status', with: 'completed')
      expect(page).to have_button('Update Invoice Status')

      select 'Cancelled', from: 'status'
      click_button('Update Invoice Status')

      expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
      expect(page).to have_field('status', with: 'cancelled')

      select 'In Progress', from: 'status'
      click_button('Update Invoice Status')

      expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
      expect(page).to have_field('status', with: 'in progress')

      select 'Completed', from: 'status'
      click_button('Update Invoice Status')

      expect(current_path).to eq(admin_invoice_path(@invoice_1.id))
      expect(page).to have_field('status', with: 'completed')
    end
  end
end
