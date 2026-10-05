require "rails_helper"

RSpec.describe ReferenceMailer, type: :mailer do
  describe "new_reference_email" do
    let(:reference) do
      Reference.create!(
        group: "vendor_category",
        value: "Equipment supplier",
        key: "equipment_supplier",
        desc: "Approved equipment vendors",
        active: true
      )
    end
    let(:mail) do
      described_class.with(reference: reference).new_reference_email
    end

    it "sends a branded summary of the new reference data" do
      expect(mail.to).to eq(["pethicklisa@gmail.com"])
      expect(mail.subject).to eq("New Netball America reference data created")
      expect(mail.html_part.body.encoded).to include("New reference data created")
      expect(mail.html_part.body.encoded).to include("vendor_category")
      expect(mail.html_part.body.encoded).to include("Equipment supplier")
      expect(mail.html_part.body.encoded).to include("Approved equipment vendors")
      expect(mail.html_part.body.encoded).to include("Netball_America_Logo")
      expect(mail.text_part.body.encoded).to include("Active: Yes")
      expect(mail.text_part.body.encoded).not_to include("&lt;br&gt;")
    end
  end
end
