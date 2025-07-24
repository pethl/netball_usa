# app/services/attendee_list_pdf_generator.rb
class AttendeeListPdfGenerator
  def initialize(event_name:)
    @event_name = event_name
    @attendees = []
  end

  def generate
    fetch_attendees
    build_pdf
  end

  private

  def fetch_attendees
    @attendees = Transfer.includes(:person, :event)
                         .joins(:event)
                         .where(events: { name: @event_name })
                         .where.not(people: { id: nil })
  end

  def build_pdf
    pdf = Prawn::Document.new
  
    pdf.image "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png", at: [462, 737], width: 80 rescue nil
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [0, 737], width: 80 rescue nil
  
    pdf.number_pages ":: Attendee List — Page <page> of <total>", at: [pdf.bounds.left, 0], size: 6, align: :left
  
    pdf.move_down 20
    pdf.text "All Attendees Grouped by Role", size: 14, style: :bold, align: :center
    pdf.text "Event: #{@event_name}", size: 10, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 8, align: :center
    pdf.move_down 20
  
    # 1. Load role order mapping from the reference table
    role_order_map = Reference.where(group: 'us_open_role')
                              .pluck(:value, :desc)
                              .to_h
                              .transform_values { |v| v.to_i } # ensure it's an integer sort key
  
    # 2. Group and sort attendees by role
    grouped_attendees = @attendees.select(&:person).group_by(&:role)
  
    sorted_roles = grouped_attendees.keys.sort_by do |role|
      role_order_map[role] || Float::INFINITY # roles not in map go last
    end
  
    # 3. Render each group in sorted order
    sorted_roles.each do |role|
      transfers = grouped_attendees[role]
  
      pdf.text "Role: #{role}", size: 10, style: :bold
      pdf.move_down 4
  
      table_data = [["Name", "Email", "Phone", "Title"]]
  
      transfers.sort_by { |t| t.person.full_name.to_s }.each do |transfer|
        person = transfer.person
        table_data << [
          person.full_name,
          person.email || "",
          person.phone || "",
          transfer.event_title || ""
        ]
      end
  
      pdf.table(table_data, header: true, row_colors: ["F9F9F9", "FFFFFF"], cell_style: { size: 8 }) do
        row(0).font_style = :bold
        row(0).background_color = "DDDDDD"
        columns(0).width = 120
        columns(1).width = 150
        columns(2).width = 100
        columns(3).width = 150
      end
  
      pdf.move_down 15
    end
  
    pdf.render
  end
  
end