# app/services/flight_details_pdf_generator.rb
class FlightDetailsPdfGenerator
  def initialize
    @attendees = []
  end

  def generate
    fetch_attendees
    build_pdf
  end

  private

  def fetch_attendees
    @attendees = Transfer
      .includes(:person, :event)
      .joins(:event)
      .where(events: { name: 'US Open 2025 - Austin' })
      .where.not(person_id: nil)
  end

  def build_pdf
    pdf = Prawn::Document.new

    # Logos (optional; safe if files missing)
    safe_image(pdf, "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png", at: [462, 737], width: 80)
    safe_image(pdf, "#{Rails.root}/app/assets/images/Netball_America_Logo.png",    at: [0,   737], width: 80)

    pdf.move_down 20
    pdf.text "Flight Details", size: 14, style: :bold, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 6, align: :center
    pdf.move_down 16

    groups = grouped_attendees(@attendees)
    if groups.values.flatten.empty?
      pdf.text "No attendees found.", size: 10, style: :italic
      return pdf.render
    end

    group_names = groups.keys
    umpires_key = group_names.find { |k| k.to_s.start_with?("Umpires") }

    if umpires_key
      render_group_section(pdf, umpires_key, groups[umpires_key])
      pdf.start_new_page
    end

    (group_names - [umpires_key]).each do |group_name|
      render_group_section(pdf, group_name, groups[group_name])
      pdf.move_down 12
    end

    pdf.render
  end

  def render_group_section(pdf, title, transfers)
    pdf.text title, size: 12, style: :bold
    pdf.move_down 6

    table_data = build_group_table(transfers)

    if table_data.length > 1
      pdf.table(table_data,
          header: true,
          row_colors: ["F8F8F8", "FFFFFF"],
          cell_style: { size: 8 }) do
        # Style both header rows
        row(0).font_style = :bold
        row(1).font_style = :bold
        row(0).background_color = "E0E0E0"
        row(1).background_color = "EFEFEF"

        # Center the grouped header cells
        row(0).align = :center

        # Column widths: name, role, then the 3+3 detail columns
        columns(0).width = 160 # Name
        columns(1).width = 90  # Role
        columns(2).width = 20  # spacer column
        columns(6).width = 20 
        # Optional: set fixed widths for detail columns
        # columns(2..4).width = 60  # Arrival Date/Flight/Time
        # columns(5..7).width = 60  # Departure Date/Flight/Time

        # Force spacer column to always white, no top/bottom borders
          columns([2,6]).style do |c|
            c.background_color = "FFFFFF"
            c.borders = [:left, :right]  # drop :top and :bottom
          end
      end
    else
      pdf.text "No flight data for this group.", size: 9, style: :italic
    end
  end

  def grouped_attendees(attendees)
    is_umpire = ->(t) { t.role.to_s.downcase.include?("umpire") }
    is_scorer = ->(t) { t.role.to_s.downcase.include?("scorer") }

    umpires   = attendees.select(&is_umpire)
    scorers   = attendees.reject(&is_umpire).select(&is_scorer)
    remaining = attendees - umpires - scorers

    other_groups = remaining
      .group_by { |t| t.role.presence || "Other" }
      .sort_by   { |role, _| role.to_s }
      .to_h

    ordered = {}
    ordered["Umpires (US + International)"] = umpires.sort_by { |t| sort_name_key(t) }
    ordered["Scorers"]                       = scorers.sort_by { |t| sort_name_key(t) }
    other_groups.each do |role, list|
      ordered[role] = list.sort_by { |t| sort_name_key(t) }
    end
    ordered
  end

  def sort_name_key(t)
    [t.person&.first_name.to_s, t.person&.last_name.to_s].join(" ")
  end

  # ===== Table (split arrival/departure) =====
  # Name | Role | Arr Date | Arr Flight | Arr Time | Dep Date | Dep Flight | Dep Time
  def build_group_table(transfers)
    top_header = [
      "Name",
      "Role",
      "", # spacer column
      { content: "Arrival", colspan: 3, align: :center },
      "", # spacer column
      { content: "Departure", colspan: 3, align: :center }
    ]
  
    sub_header = [
      "", "", "",                        # (Name, Role)
      "Date", "Flight", "Time",
      "",                             # spacer
      "Date", "Flight", "Time"
    ]
  
    rows = transfers.map do |t|
      p = t.person
      [
        (p&.try(:full_name).presence || [p&.first_name, p&.last_name].compact.join(" ").presence || "—"),
        (t.role.presence || p&.role.presence || "—"),
        "", # spacer cell
        format_date(t.arrival_time),
        (t.arrival_flight.presence || "—"),
        format_time(t.arrival_time),
        "", # spacer cell
        format_date(t.departure_time),
        (t.departure_flight.presence || "—"),
        format_time(t.departure_time)
      ]
    end
  
    [top_header, sub_header] + rows
  end
  
  

  def format_date(dt)
    dt.present? ? dt.strftime("%b-%d").upcase : "—"
  end

  def format_time(dt)
    dt.present? ? dt.strftime("%H:%M") : "—"
  end

  def safe_image(pdf, path, **opts)
    File.exist?(path) ? pdf.image(path, **opts) : nil
  end
end
