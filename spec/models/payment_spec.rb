require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { Payment.new(payment_year: "2024", payment_type: "Paypal", amount: 70.00 )}
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end
    it "is not valid without a payment_year" do
      subject.payment_year=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without a payment_type" do
      subject.payment_type=nil
      expect(subject).to_not be_valid
    end
    it "is not valid without an amount" do
      subject.amount=nil
      expect(subject).to_not be_valid
    end
    it "is valid with na_team_id and all fields filled" do
    subject { Payment.new(payment_year: "2024", payment_type: "Paypal", amount: 70.00, na_team_id:3, payment_received_date: DateTime.now, payment_transaction_reference: "KLM29x06_71", payment_notes: "Delayed system update due to vacation" )}
      expect(subject).to be_valid
    end
    it "is valid with individual_member_id and all fields filled" do
      subject { Payment.new(payment_year: "2024", payment_type: "Paypal", amount: 70.00, individual_member_id:2, payment_received_date: DateTime.now, payment_transaction_reference: "KLM29x06_71", payment_notes: "Delayed system update due to vacation" )}
        expect(subject).to be_valid
      end
      it "is not valid with both individual_member_id and na_team_id completed" do
        subject { Payment.new(payment_year: "2024", payment_type: "Paypal", amount: 70.00, individual_member_id:2, na_team_id:3, payment_received_date: "2024-07-03 00:00:00", payment_transaction_reference: "KLM29x06_71", payment_notes: "Delayed system update due to vacation" )}
        expect(subject).to_not be_valid
      end
  
end

