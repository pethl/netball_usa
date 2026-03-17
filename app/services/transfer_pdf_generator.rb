class TransferPdfGenerator
  def initialize(start_date: Date.today.beginning_of_year, event_name: nil)
    @start_date = start_date
    @event_name = event_name
    @transfers = []
  end

  def generate
    fetch_transfers
    build_pdf
  end

  private

  def fetch_transfers
    return @transfers = Transfer.none unless @event_name.present?

    event = Event.find_by(name: @event_name)
    return @transfers = Transfer.none unless event

    @transfers = Transfer.joins(:event)
                         .where(events: { id: event.id })
                         .where(arrival_airport_transport_request: "Yes - Requesting transport")
                         .where.not(arrival_time: nil)
                         .order(arrival_time: :asc, arrival_airline: :asc)

    @transfers_by_arrival_date_only = @transfers.group_by(&:arrival_date_only)
  end

  def build_pdf
    pdf = Prawn::Document.new
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [462, 737], width: 80
    title_event = @event_name.presence || "Unknown Event"
    pdf.text ":: NETBALL AMERICA ::", size: 6
    pdf.text "Arrivals Transfers Sheet \n #{title_event}", size: 14, style: :bold, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 6, align: :right
    pdf.move_down 6

    col_widths = {
      0 => 20,  # GP
      1 => 65,  # Name
      2 => 55,  # Phone
      3 => 25,  # Arrv Time
      4 => 35,  # Flight
      5 => 50,  # Airline & Term.
      6 => 50,  # PickUp
      7 => 50,  # Pick Up Location
      8 => 80,  # Hotel
      9 => 80   # Notes
    }

    (@transfers_by_arrival_date_only || {}).each do |arrival_date_only, transfers|
      # Day header
      first_transfer = transfers.first
      if first_transfer && first_transfer.arrival_time
        day_label = "#{first_transfer.arrival_time.strftime('%A')}   #{arrival_date_only}"
      else
        day_label = arrival_date_only.to_s
      end
      pdf.text day_label, size: 12, style: :bold
      pdf.move_down 4

      transfers.group_by(&:pick_up_grouping).each do |grouping, group_transfers|
        pickup_time = group_transfers.first&.grouping_pickup_time&.strftime("%-l:%M %p")
        group_header = "Group #{grouping} – Pickup Time: #{pickup_time}"

        # Build table data
        transfer_table_data = [["GP", "Name", "Phone", "Arrv. Time", "Flight", "Airline & Term.", "PickUp", "Pick Up Location", "Hotel", "Notes"]]
        group_transfers.each do |t|
          transfer_table_data << [
            t.pick_up_grouping,
            t.person&.full_name.to_s,
            t.arrival_phone.to_s,
            t.arrival_time&.strftime('%H:%M').to_s,
            t.arrival_flight.to_s,
            t.arrival_airline_and_terminal.to_s,
            t.pickup_type.to_s,
            t.pickup_location.to_s,
            t.hotel_name.to_s,
            t.pickup_note.to_s
          ]
        end

        # Measure header and table heights (use same options for accurate estimate)
        header_height = pdf.height_of(group_header, size: 10, style: :italic)
        measured = pdf.make_table(transfer_table_data,
                                  header: true,
                                  cell_style: { inline_format: true, size: 6, padding: 4 },
                                  column_widths: col_widths)

        total_needed = header_height + 2 + measured.height + 12

        # If the whole block fits on a page but there's not enough space on current page, start new page.
        if measured.height <= pdf.bounds.height
          pdf.start_new_page if pdf.cursor < total_needed
        end
        # If the block is larger than a page we let Prawn split it (header row will repeat).

        # Render header then table
        pdf.text group_header, size: 10, style: :italic, align: :left
        pdf.move_down 2

        pdf.table(transfer_table_data,
                  header: true,
                  width: 510,
                  column_widths: col_widths,
                  row_colors: ["F8F8F8", "FFFFFF"],
                  cell_style: { inline_format: true, size: 6, padding: 4 }) do
          row(0).font_style = :bold
          row(0).background_color = "E0E0E0"
          columns(2..4).align = :right
        end

        pdf.move_down 10
      end

      pdf.move_down 12
    end

    pdf.render
  end
end

