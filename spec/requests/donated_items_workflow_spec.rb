# spec/requests/donated_items_workflow_spec.rb
require "rails_helper"

RSpec.describe "Donated items workflow", type: :request do
  include ActiveJob::TestHelper

  let(:admin) { create(:user, :admin) }
  let(:requester) { create(:user, :with_donated_items_access) }

  around do |example|
    perform_enqueued_jobs { example.run }
  end

  it "covers create, request, approve, and admin viewing approved item request details" do
    #
    # 1. Admin creates donated item
    #
    sign_in admin

    expect {
      post donated_items_path, params: {
        donated_item: attributes_for(:donated_item)
      }
    }.to change(DonatedItem, :count).by(1)

    donated_item = DonatedItem.last

    expect(response).to redirect_to(donated_items_path)
    expect(donated_item.status).to eq("Available")

    get donated_items_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Amazon eGift Card")
    expect(response.body).to include("Request Item")

    #
    # 2. Eligible user requests donated item
    #
    sign_in requester

    get donated_items_path

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Amazon eGift Card")
    expect(response.body).to include("Request Item")

    expect {
      post donated_item_requests_path, params: {
        donated_item_request: attributes_for(
          :donated_item_request,
          donated_item_id: donated_item.id
        )
      }
    }.to change(DonatedItemRequest, :count).by(1)
     .and have_enqueued_mail(DonatedItemRequestMailer, :request_submitted)

    donated_item_request = DonatedItemRequest.last

    expect(response).to redirect_to(donated_items_path(status: "Requested"))

    expect(donated_item.reload.status).to eq("Requested")
    expect(donated_item_request.status).to eq("Pending")
    expect(donated_item_request.requested_by).to eq(requester)

    get donated_items_path(status: "Requested")

    expect(response.body).to include("Requested by")
    expect(response.body).to include(requester.full_name)
    expect(response.body).not_to include("Review Request")

    #
    # 3. Admin reviews and approves request
    #
    sign_in admin

    get donated_items_path(status: "Requested")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Review Request")
    expect(response.body).to include("Amazon eGift Card")

    get donated_item_request_path(donated_item_request)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Volunteer recognition prize")
    expect(response.body).to include("Jane Smith")
    expect(response.body).to include("Pending")

    expect {
      patch approve_donated_item_request_path(donated_item_request), params: {
        donated_item_request: {
          admin_notes: "Approved for volunteer recognition"
        }
      }
    }.to have_enqueued_mail(DonatedItemRequestMailer, :request_approved)

    expect(response).to redirect_to(donated_item_request_path(donated_item_request))

    donated_item_request.reload
    donated_item.reload

    expect(donated_item_request.status).to eq("Approved")
    expect(donated_item_request.admin_notes).to eq("Approved for volunteer recognition")
    expect(donated_item_request.approved_by).to eq(admin)
    expect(donated_item_request.approved_at).to be_present
    expect(donated_item.status).to eq("Approved")

    get donated_items_path(status: "Approved")

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Approved for")
    expect(response.body).to include("Jane Smith")
    expect(response.body).to include("Amazon eGift Card")

    #
    # 4. Admin can open approved donated item and see request details
    #
    get donated_item_path(donated_item)

    expect(response).to have_http_status(:ok)
    expect(response.body).to include("Amazon eGift Card")
    expect(response.body).to include("Approved")
    expect(response.body).to include("Jane Smith")
    expect(response.body).to include("Volunteer recognition prize")
    expect(response.body).to include("Approved for volunteer recognition")
    expect(response.body).to include(requester.full_name)
  end
end