class PeoplePdfService
    require "prawn"
  
    def initialize(people)
      @people = people
    end
  
    def generate
      Prawn::Document.new do |pdf|
        pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [462, 737], width: 80
        pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}\n", size: 6, align: :left
      
        pdf.text "US & Canada Umpire Details", size: 20, style: :bold, align: :center
         pdf.move_down 20
  
        table_data = [["Last Name", "First Name", "Location", "Email", "Phone"]]
  
        @people.each do |person|
          table_data << [
            person.last_name,
            person.first_name,
            person.location,
            person.email,
            person.phone
          ]
        end
  
        pdf.table(table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], width: pdf.bounds.width)
      end
    end
  end
  