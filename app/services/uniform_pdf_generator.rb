class UniformPdfGenerator
  def initialize
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
                         .where(events: { name: 'US Open 2025 - Austin' })
                         .where.not(people: { id: nil }) # just to be safe
  end

  def build_pdf
    pdf = Prawn::Document.new

    # Logos
    pdf.image "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png", at: [462, 737], width: 80
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [0, 737], width: 80

    # Page footer
    pdf.number_pages ":: U.S. Open Netball Championships® — Page <page> of <total>",
                     at: [pdf.bounds.left, 0],
                     size: 6,
                     align: :left

    # Title & date
    pdf.move_down 20
    pdf.text "Uniforms & T-Shirts Sheet", size: 14, style: :bold, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 6, align: :center
    pdf.move_down 30

    # -------------------------------
    # 👕 T-SHIRT SIZE SUMMARY
    # -------------------------------
    pdf.text "T-Shirt Sizes Summary", size: 10, style: :bold
    pdf.move_down 4

    size_counts = @attendees
                    .select { |t| t.person.present? }
                    .group_by { |t| t.person.tshirt_size.to_s.strip.presence || "N/A" }
                    .transform_values(&:count)
                    .sort.to_h

    summary_data = [["T-Shirt Size", "Count"]]
    size_counts.each do |size, count|
      summary_data << [size, count]
    end

    pdf.table(summary_data, width: 200, cell_style: { size: 8 }) do
      row(0).font_style = :bold
      row(0).background_color = "CCCCCC"
    end

    pdf.move_down 10

    # -------------------------------
    # 👕 T-SHIRT SIZE DETAILED LIST
    # -------------------------------
    pdf.text "T-Shirt Sizes - Full List", size: 8, style: :bold
    pdf.move_down 2

    tshirt_table_data = [["", "Name", "Role", "T-Shirt Size"]]
    @attendees
      .select { |t| t.person.present? }
      .sort_by { |t| t.person.first_name.to_s }
      .each do |transfer|
        person = transfer.person
        tshirt_table_data << [
          "",  # tick column left blank for manual check
          person.full_name,
          person.role,
          person.tshirt_size || "N/A"
        ]
      end

    if tshirt_table_data.length > 1
      pdf.table(tshirt_table_data, header: true, row_colors: ["F8F8F8", "FFFFFF"], cell_style: { size: 6 }) do
        row(0).font_style = :bold
        row(0).background_color = "E0E0E0"
        columns(0).width = 20
      end
    else
      pdf.text "No T-Shirt data found.", size: 10, style: :italic
    end

    pdf.move_down 10

    # -------------------------------
    # 🚫 MISSING T-SHIRT SIZE TABLE
    # -------------------------------

    pdf.text "Missing T-Shirt Sizes", size: 8, style: :bold
    pdf.move_down 3

    missing_tshirt_data = [["Name", "Role"]]

    @attendees
      .select { |t| t.person&.tshirt_size.to_s.strip.blank? }
      .each do |transfer|
        person = transfer.person
        next unless person

        missing_tshirt_data << [
          person.full_name,
          person.role
        ]
      end

    if missing_tshirt_data.length > 1
      pdf.table(missing_tshirt_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { size: 6 }) do
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
      end
    else
      pdf.text " All attendees have submitted a t-shirt size!", size: , style: :italic
    end

    pdf.move_down 30

    # -------------------------------
    # 🧾 UNIFORM ITEM SUMMARY GRID
    # -------------------------------
    pdf.start_new_page
    pdf.text "Uniform Summary Grid", size: 12, style: :bold
    pdf.move_down 10

    # Define the fields and labels
    uniform_fields = {
      inferno_bottom_skirt_size: "Inferno Bottom Skirt Size",
      inferno_bottom_shorts_size: "Inferno Bottom Shorts Size",
      inferno_top_polo_size: "Inferno Top Polo Size",
      inferno_top_vneck_size: "Inferno Top V-Neck Size"
    }

    # Get all attendees
    people = @attendees.map(&:person).compact

    # Collect all size options
    all_sizes = people.flat_map do |p|
      uniform_fields.keys.map { |field| p.send(field).to_s.strip.presence }
    end.compact.uniq.sort

    # Ensure common sizes appear in order
    common_order = %w[XXS XS S M L XL XXL XXXL]
    ordered_sizes = (common_order & all_sizes) + (all_sizes - common_order)

    # Build header row
    header_row = ["Item"] + ordered_sizes

    # Build each row per field
    summary_rows = uniform_fields.map do |field, label|
      counts = people.group_by { |p| p.send(field).to_s.strip.presence || "N/A" }.transform_values(&:count)

      row = [label]
      ordered_sizes.each do |size|
        row << (counts[size] || 0)
      end
      row
    end

    # Final table data
    uniform_summary_table = [header_row] + summary_rows

    # Render table
    pdf.table(uniform_summary_table, header: true, cell_style: { size: 8 }) do
      row(0).font_style = :bold
      row(0).background_color = "CCCCCC"
      columns(0).font_style = :bold

      columns(1).width = 30  # Skirt
      columns(2).width = 30  # Skirt
      columns(3).width = 30  # Shorts
      columns(4).width = 30  # Polo
      columns(5).width = 30  # Polo

      # Right-align those columns
      columns(1..5).align = :right
     
    end

    pdf.move_down 20

    # -------------------------------
    # 🥋 UNIFORM SIZE TABLE (Umpires only)
    # -------------------------------
    pdf.text "Uniform Sizes (Umpires Only)", size: 10, style: :bold
    pdf.move_down 4

    uniform_table_data = [["Name", "Role", "Skirt", "Shorts", "Polo", "V-Neck"]]

    @attendees
      .select { |t| t.role.to_s.include?("Umpire") && t.person.present? }
      .sort_by { |t| t.person.first_name.to_s }
      .each do |transfer|
        person = transfer.person
        uniform_table_data << [
          person.full_name,
          transfer.role,
          person.inferno_bottom_skirt_size || "N/A",
          person.inferno_bottom_shorts_size || "N/A",
          person.inferno_top_polo_size || "N/A",
          person.inferno_top_vneck_size || "N/A"
        ]
      end

    if uniform_table_data.length > 1
      pdf.table(uniform_table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { size: 9 }) do
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"

        # Set fixed widths for the last four columns
        columns(2).width = 50  # Skirt
        columns(3).width = 50  # Shorts
        columns(4).width = 50  # Polo
        columns(5).width = 50  # V-Neck

        # Optionally set widths for name and role
        columns(0).width = 150  # Name
        columns(1).width = 80   # Role
      end
    else
      pdf.text "No umpire uniform data found.", size: 10, style: :italic
    end

    pdf.render
  end
end
