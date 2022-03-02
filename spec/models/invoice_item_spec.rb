require 'rails_helper'

RSpec.describe InvoiceItem do
  describe 'validations' do
    it { should define_enum_for(:status).with({:pending => 0, :packaged => 1, :shipped => 2}) }
    it { should validate_presence_of(:quantity) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_presence_of(:item_id) }
    it { should validate_presence_of(:invoice_id) }
  end

  describe 'relationships' do
    it { should belong_to :invoice }
    it { should belong_to :item }
  end
end
