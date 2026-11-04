require "rails_helper"

RSpec.describe EventTransportsController, type: :routing do
  it { expect(get: "/event_transports").to route_to("event_transports#index") }
  it { expect(get: "/event_transports/new").to route_to("event_transports#new") }
  it { expect(get: "/event_transports/1/edit").to route_to("event_transports#edit", id: "1") }
  it { expect(get: "/event_transports_pdf.pdf").to route_to("event_transports#pdf", format: "pdf") }
end
