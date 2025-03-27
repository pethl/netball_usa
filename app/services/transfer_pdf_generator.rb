# app/services/transfer_pdf_generator.rb
class TransferPdfGenerator
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
                           .where.not(arrival_time: nil)
                           .order(arrival_time: :asc, arrival_airline: :asc)
  
      @transfers_by_arrival_date_only = @transfers.group_by(&:arrival_date_only)
    end
  
    def build_pdf
        pdf = Prawn::Document.new
        pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [462, 737], width: 80
        pdf.text ":: NETBALL AMERICA :: US Open #{@start_date.strftime('%Y')}\n", size: 6
        pdf.text "Arrivals Transfers Sheet", size: 14, style: :bold, align: :center
        pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}\n", size: 6, align: :right
        pdf.move_down 6
      
        @transfers_by_arrival_date_only.each do |arrival_date_only, transfers|
          pdf.text "#{transfers.first.arrival_time.strftime('%A')}   #{arrival_date_only}", size: 12, style: :bold
          pdf.move_down 4
      
          # Group by pick_up_grouping within each day
          transfers.group_by(&:pick_up_grouping).each do |grouping, group_transfers|
            pickup_time = group_transfers.first.grouping_pickup_time&.strftime("%-l:%M %p")
            pdf.text "Group #{grouping} – Pickup Time: #{pickup_time}", size: 10, style: :italic, align: :left

            pdf.move_down 2
      
            transfer_table_data = [["GP", "Name", "Phone", "Arrv. Time", "Flight", "Airline & Term.", "PickUp", "Pick Up Location", "Hotel", "Notes"]]
            group_transfers.each do |t|
              transfer_table_data << [
                t.pick_up_grouping,
                t.person.full_name,
                t.phone,
                t.arrival_time.strftime('%H:%M'),
                t.arrival_flight,
                t.arrival_airline_and_terminal,
                t.pickup_type,
                t.pickup_location,
                t.hotel_name,
                t.pickup_note
              ]
            end
      
            pdf.table(transfer_table_data, width: 510, cell_style: { inline_format: true, size: 6 }) do
              row(0).font_style = :bold
              columns(0).width = 20
              columns(1).width = 70
              columns(2).width = 40
              columns(3).width = 25
              columns(4).width = 35
              columns(5).width = 60
              columns(6).width = 50
              columns(7).width = 50
              columns(8).width = 80
              columns(9).width = 80
              columns(2..4).align = :right
            end
      
            pdf.move_down 10
          end
      
          pdf.move_down 12
        end
      
        pdf.render
      end
    end      
  