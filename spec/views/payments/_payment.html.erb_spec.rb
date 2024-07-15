# spec/views/payments/_payment.html.erb_spec.rb

describe 'payments/_product.html.erb' do
    context 'when the payment has a type' do
      it 'displays the type' do
        assign(:payments, build(:payments, payment_type: 'Paypal'))
  
        render
  
        expect(rendered).to have_field 'Payment Type'
      end
    end
  
    context 'when the payment type is nil' do
      it "displays 'None'" do
        assign(:payments, build(:payments, url: nil))
  
        render
  
        expect(rendered).to have_content 'None'
      end
    end
  end