class EventTransportPdfGenerator
  def initialize(transfer_event_id:)
    @transfer_event = Event.find(transfer_event_id)
  end

  def generate
    transports = EventTransport
                 .includes(event_transport_passengers: :person)
                 .where(transfer_event_id: @transfer_event.id)
                 .scheduled

    build_pdf(transports)
  end

  private

  def build_pdf(transports)
    pdf = Prawn::Document.new(page_layout: :landscape)
    pdf.image Rails.root.join("app/assets/images/Netball_America_Logo.png"),
              at: [pdf.bounds.right - 80, pdf.bounds.top],
              width: 80
    pdf.text ":: NETBALL AMERICA ::", size: 8
    pdf.text "Event Transport\n#{@transfer_event.name}", size: 16, style: :bold, align: :center
    pdf.text "Print Date: #{Date.current.strftime('%b %d, %Y')}", size: 8, align: :right
    pdf.move_down 10

    transports.group_by { |transport| transport.departure_at.to_date }.each do |date, daily_transports|
      rows = [["Depart", "Arrive", "From", "To", "Driver", "Passengers / Phone", "Notes / Equipment"]]
      daily_transports.each do |transport|
        passengers = transport.event_transport_passengers.map do |passenger|
          [passenger.display_name, passenger.display_phone].compact_blank.join(" — ")
        end.join("\n")

        rows << [
          departure_cell(transport),
          transport.arrival_at&.strftime("%-l:%M %p").to_s,
          transport.pickup_location,
          transport.destination,
          transport.driver_name.to_s,
          passengers,
          transport.notes.to_s
        ]
      end

      table_options = {
        header: true,
        width: pdf.bounds.width,
        row_colors: %w[F8F8F8 FFFFFF],
        column_widths: [55, 55, 115, 115, 80, 180, 120],
        cell_style: { size: 9, padding: 4 }
      }
      heading = date.strftime("%A, %B %-d, %Y")
      minimum_section_height = pdf.height_of(heading, size: 14, style: :bold) +
                               4 + pdf.make_table(rows.first(2), table_options).height
      pdf.start_new_page if pdf.cursor < minimum_section_height

      pdf.text heading, size: 14, style: :bold
      pdf.move_down 4

      pdf.table(rows, table_options) do
        row(0).font_style = :bold
        row(0).background_color = "E0E0E0"
      end
      pdf.move_down 12
    end

    pdf.text "No transport journeys have been scheduled." if transports.empty?
    pdf.render
  end

  def departure_cell(transport)
    passenger_count = transport.event_transport_passengers.size
    passenger_label = passenger_count == 1 ? "1 person" : "#{passenger_count} people"

    {
      content: "<b>#{transport.departure_at.strftime('%-l:%M %p')}</b>\n" \
               "<font size=\"7\" color=\"777777\">#{passenger_label}</font>",
      inline_format: true
    }
  end
end
