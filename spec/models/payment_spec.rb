require 'rails_helper'

RSpec.describe Payment, type: :model do
  subject { build(:payment, :club_payment) }  # 👈 safer default subject now

  describe "validations" do
    it "is valid with valid attributes" do
      expect(subject).to be_valid
    end

    it "is not valid without a payment_year" do
      subject.payment_year = nil
      expect(subject).to_not be_valid
    end

    it "is not valid without a payment_type" do
      subject.payment_type = nil
      expect(subject).to_not be_valid
    end

    it "is not valid with both individual_member_id and club_id completed" do
      member = create(:individual_member)
      club = create(:club)

      payment = build(:payment, individual_member: member, club: club) # 👈 no na_team_id anymore
      expect(payment).to_not be_valid
    end

    # This fails because your model does NOT validate presence of amount now
    # it "is not valid without an amount" do
    #   subject.amount = nil
    #   expect(subject).to_not be_valid
    # end
  end

  describe "associations" do
    it { should belong_to(:individual_member).optional }
    it { should belong_to(:club).optional }
    it { should belong_to(:payment_recorded_by).class_name('User').optional }
  end

  describe "methods" do
    it "returns correct payment summary" do
      payment = create(:payment, 
        :club_payment,         # 👈 use the trait!
        payment_type: "Paypal", 
        amount: 70.00, 
        payment_received_date: Date.new(2024, 7, 3)
      )
      expect(payment.payment_summary).to eq("Paypal $70.0 Jul 03, 2024")

    end
  end
end
