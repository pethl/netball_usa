# spec/features/donated_items_workflow_spec.rb
require "rails_helper"
require "securerandom"

#
# Workflow:
#
# 1. Admin creates donated item
# 2. Eligible user requests item
# 3. Request email sent
# 4. Admin reviews and approves with club assignment
# 5. Approval email sent
# 6. Admin can later view request details from donated item
#

RSpec.describe "Donated items workflow", type: :feature do
  include ActiveJob::TestHelper

  let(:admin) { create(:user, :admin) }
  let(:requester) { create(:user, :donated_items_access) }
  let!(:club) { create(:club, name: "ZZZ Spec Club #{SecureRandom.hex(4)}") }

  before do
    ActionMailer::Base.deliveries.clear
  end

  it "covers create, request, approve with club, and admin viewing approved request details on donated item show page" do
    #
    # 1. Admin creates donated item
    #
    login_as(admin, scope: :user)

    visit donated_items_path
    click_link "Add New Donated Item"

    fill_in "Item Description*", with: "Amazon eGift Card"
    select "E-Gift Card", from: "Item Type*"
    select "Available", from: "Status*"
    fill_in "Value $", with: "25"
    fill_in "Donor Name", with: "Amazon Community Giving"
    fill_in "Any Other Requirement", with: "Use for volunteer recognition"

    click_button "Save Record"

    expect(page).to have_content("Donated item was successfully created.")
    expect(page).to have_content("Amazon eGift Card")
    expect(page).to have_content("Request Item")

    donated_item = DonatedItem.last

    expect(donated_item.status).to eq("Available")

    logout(:user)

    #
    # 2. User with donated_items_access requests item
    #
    login_as(requester, scope: :user)

    visit donated_items_path

    expect(page).to have_content("Amazon eGift Card")
    expect(page).to have_link("Request Item")

    click_link "Request Item"

    expect(page).to have_content("Donated Item Requested")
    expect(page).to have_content("Amazon eGift Card")

    fill_in "What is this item for?*", with: "Volunteer recognition prize"
    fill_in "Recipient Name*", with: "Jane Smith"
    fill_in "Recipient Phone*", with: "555-123-4567"
    select "Email", from: "Delivery Method*"
    fill_in "Date Needed By*", with: 2.weeks.from_now.to_date.to_s
    fill_in "Delivery Email", with: "jane@example.com"

    expect {
      perform_enqueued_jobs do
        click_button "Submit Request"
      end
    }.to change(DonatedItemRequest, :count).by(1)
     .and change(ActionMailer::Base.deliveries, :count).by(1)

    donated_item_request = DonatedItemRequest.last

    expect(page).to have_content("Donated item request was successfully submitted.")

    expect(donated_item.reload.status).to eq("Requested")
    expect(donated_item_request.status).to eq("Pending")
    expect(donated_item_request.requested_by).to eq(requester)

    visit donated_items_path(status: "Requested")

    expect(page).to have_content("Requested by")
    expect(page).to have_content(requester.full_name)
    expect(page).not_to have_content("Review Request")

    logout(:user)

    #
    # 3. Admin reviews and approves request with club assignment
    #
    login_as(admin, scope: :user)

    visit donated_items_path(status: "Requested")

    expect(page).to have_content("Amazon eGift Card")
    expect(page).to have_link("Review Request")

    click_link "Review Request"

    expect(page).to have_content("Review Donated Item Request")
    expect(page).to have_content("Request Details")
    expect(page).to have_content("Volunteer recognition prize")
    expect(page).to have_content("Jane Smith")
    expect(page).to have_content("Pending")
    expect(page).to have_select("Club", with_options: [club.name])

    select club.name, from: "Club"

    expect {
      perform_enqueued_jobs do
        click_button "Approve"
      end
    }.to change(ActionMailer::Base.deliveries, :count).by(1)

    expect(page).to have_content("Donated item request was approved.")

    donated_item_request.reload
    donated_item.reload

    expect(donated_item_request.status).to eq("Approved")
    expect(donated_item_request.approved_by).to eq(admin)
    expect(donated_item_request.approved_at).to be_present
    expect(donated_item.status).to eq("Approved")
    expect(donated_item.club).to eq(club)
    expect(donated_item.program).to be_nil

    #
    # 4. Admin opens approved donated item and sees request details
    #
    visit donated_items_path(status: "Approved")

    expect(page).to have_content("Approved for")
    expect(page).to have_content("Jane Smith")
    expect(page).to have_content("Amazon eGift Card")
    expect(page).to have_content(club.name)

    click_link "Amazon eGift Card"

    expect(page).to have_content("Amazon eGift Card")
    expect(page).to have_content("Approved")
    expect(page).to have_content(club.name)
    expect(page).to have_content("Latest Request")
    expect(page).to have_content(requester.full_name)
    expect(page).to have_content("Volunteer recognition prize")
    expect(page).to have_content("Jane Smith")
    expect(page).to have_content("555-123-4567")
    expect(page).to have_content("Email")
    expect(page).to have_content("jane@example.com")
  end
end