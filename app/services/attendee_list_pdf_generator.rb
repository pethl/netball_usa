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
    scope = Transfer.includes(:event, :person)
                    .joins(:event)
                    .where(events: { name: @event_name })
                    .where.not(people: { id: nil }) # relies on the includes(:person)

    # If Person has a :contact or :contacts association, eager-load it (optional)
    if Person.reflections.key?("contact")
      scope = scope.includes(person: :contact)
    elsif Person.reflections.key?("contacts")
      scope = scope.includes(person: :contacts)
    end

    @attendees = scope
  end

  # Safely fetch a T-shirt size from possible locations
  def tshirt_for(person)
    return "" unless person

    return person.tshirt_size.to_s if person.respond_to?(:tshirt_size)

    if person.respond_to?(:contact) && person.contact&.respond_to?(:tshirt_size)
      return person.contact.tshirt_size.to_s
    end

    if person.respond_to?(:contacts)
      first = person.contacts.first
      return first.tshirt_size.to_s if first&.respond_to?(:tshirt_size)
    end

    ""
  end

  def build_pdf
    pdf = Prawn::Document.new

    pdf.image "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png", at: [462, 737], width: 80 rescue nil
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png",     at: [0,   737], width: 80 rescue nil

    pdf.number_pages ":: Attendee List — Page <page> of <total>", at: [pdf.bounds.left, 0], size: 6, align: :left

    pdf.move_down 20
    pdf.text "All Attendees Grouped by Role", size: 14, style: :bold, align: :center
    pdf.text "Event: #{@event_name}", size: 10, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 8, align: :center
    pdf.move_down 20

    # Order mapping from references (value => order)
    role_order_map = Reference.where(group: 'us_open_role')
                              .pluck(:value, :desc)
                              .to_h
                              .transform_values { |v| v.to_i }

    # Merge roles
    merge_role = ->(role) do
      case role
      when 'US Umpire', 'Int Umpire' then 'Umpire'
      else role.to_s
      end
    end

    # Sort key for merged labels
    sort_key_for = ->(label) do
      return role_order_map[label] if role_order_map.key?(label)
      if label == 'Umpire'
        keys = ['US Umpire', 'Int Umpire'].map { |r| role_order_map[r] }.compact
        return keys.min unless keys.empty?
      end
      Float::INFINITY
    end

    # Group by merged role
    grouped = Hash.new { |h, k| h[k] = [] }
    @attendees.each do |t|
      next unless t.person
      grouped[merge_role.call(t.role)] << t
    end

    sorted_roles = grouped.keys.sort_by { |r| sort_key_for.call(r) }

    # ---- Columns (keep total ~520) ----
    # New order: Name | Title | Email | Phone | T-Shirt
    col_widths = { name: 120, title: 120, email: 140, phone: 80, tshirt: 60 }

    sorted_roles.each do |role|
      transfers = grouped[role]

      pdf.text "Role: #{role}", size: 10, style: :bold
      pdf.move_down 4

      table_data = [["Name", "Title", "Email", "Phone", "T-Shirt"]]

      transfers.sort_by { |t| t.person.full_name.to_s }.each do |transfer|
        person = transfer.person
        table_data << [
          person&.full_name.to_s,
          transfer.event_title.to_s,  # Title now 2nd
          person&.email.to_s,
          person&.phone.to_s,
          tshirt_for(person)
        ]
      end

      pdf.table(table_data,
                header: true,
                row_colors: %w[F9F9F9 FFFFFF],
                cell_style: { size: 8 }) do
        row(0).font_style = :bold
        row(0).background_color = "DDDDDD"
        columns(0).width = col_widths[:name]
        columns(1).width = col_widths[:title]
        columns(2).width = col_widths[:email]
        columns(3).width = col_widths[:phone]
        columns(4).width = col_widths[:tshirt]
      end

      pdf.move_down 15
    end

    pdf.render
  end
end
