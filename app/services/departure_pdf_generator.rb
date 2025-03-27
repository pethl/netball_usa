class DeparturePdfGenerator
    def initialize(start_date: Date.today.beginning_of_year)
      @start_date = start_date
    end
  
    def generate
      fetch_transfers
      build_pdf
    end
  
    private
  
    def fetch_transfers
      @transfers = Transfer.joins(:event)
                           .where(events: { name: 'US Open 2025 - Austin' })
                           .where(airport_transport_request: "Yes - Requesting transport")
                           .where.not(departure_time: nil)
                           .order(departure_time: :asc, departure_airline: :asc)
  
      @transfers_by_departure_date_only = @transfers.group_by(&:departure_date_only)
    end
  
    def build_pdf
      pdf = Prawn::Document.new
      pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [462, 737], width: 80
      pdf.text ":: NETBALL AMERICA :: US Open #{@start_date.strftime('%Y')}\n", size: 6
      pdf.text "Departures Transfers Sheet", size: 14, style: :bold, align: :center
      pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}\n", size: 6, align: :right
      pdf.move_down 6
  
      @transfers_by_departure_date_only.each do |departure_date_only, transfers|
        pdf.text "#{transfers.first.departure_time.strftime('%A')}   #{departure_date_only}", size: 12, style: :bold
        pdf.move_down 4
  
        transfers.group_by(&:departure_grouping).sort.to_h.each do |grouping, group_transfers|
          time = group_transfers.first.grouping_departure_time&.strftime("%-l:%M %p")
          pdf.text "Group #{grouping} – Departure Time: #{time}", size: 9, style: :italic, align: :left
          pdf.move_down 2
  
          table_data = [["Grouping", "Name", "Phone", "Dep. Time", "Flight", "Airline & Term.", "PickUp", "Hotel", "Notes"]]
          group_transfers.each do |t|
            table_data << [
              t.departure_grouping,
              t.person.full_name,
              t.phone,
              t.departure_time.strftime('%H:%M'),
              t.departure_flight,
              t.departure_airline_and_terminal,
              t.departure_type,
              t.hotel_name,
              t.departure_note
            ]
          end
  
          pdf.table(table_data, width: 545, cell_style: { inline_format: true, size: 6 }) do
            row(0).font_style = :bold
            columns(0).width = 40
            columns(1).width = 90
            columns(2).width = 50
            columns(3).width = 30
            columns(4).width = 35
            columns(5).width = 60
            columns(6).width = 60
            columns(7).width = 80
            columns(8).width = 100
            columns(2..4).align = :right
          end
  
          pdf.move_down 10
        end
  
        pdf.move_down 12
      end
  
      pdf.render
    end
  end
  