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
                         .where.not(people: { id: nil })
  end

  def build_pdf
    pdf = Prawn::Document.new

    pdf.image "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png", at: [462, 737], width: 80
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png", at: [0, 737], width: 80

    pdf.move_down 20
    pdf.text "Uniforms & T-Shirts Sheet", size: 14, style: :bold, align: :center
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 6, align: :center
    pdf.move_down 30

    pdf.text "T-Shirt Sizes Summary", size: 10, style: :bold
    pdf.move_up 12
    pdf.indent(270) do
      pdf.text "Missing T-Shirt Sizes", size: 10, style: :bold
    end
    pdf.move_down 4

    ordered_tshirt_sizes = ["XS", "Small", "Medium", "Large", "XL", "2XL", "3XL", "4XL", "Size Not Yet Given"]
    size_counts = @attendees.group_by { |t| t.person&.tshirt_size.to_s.strip.presence || "Size Not Yet Given" }
                             .transform_values(&:count)

    sorted_size_counts = ordered_tshirt_sizes.map { |size| [size, size_counts[size] || 0] }
    total_count = sorted_size_counts.sum { |_, count| count }
    sorted_size_counts << ["Total", total_count]
    summary_data = [["T-Shirt Size", "Count"]] + sorted_size_counts

    missing_data = [["Name", "Role"]]
    @attendees.select { |t| t.person&.tshirt_size.to_s.strip.blank? }
              .each { |t| missing_data << [t.person.full_name, t.person.role] if t.person }

    missing_data << ["All attendees", "have submitted a size"] if missing_data.size == 1

    combined_table = [
      [
        pdf.make_table(summary_data, cell_style: { size: 8 }) do
          row(0).font_style = :bold
          row(0).background_color = "CCCCCC"
          row(-1).font_style = :bold if summary_data.length > 2
        end,
        pdf.make_table(missing_data, cell_style: { size: 8 }) do
          row(0).font_style = :bold
          row(0).background_color = "CCCCCC"
        end
      ]
    ]

    pdf.table(combined_table, cell_style: { borders: [] }, width: pdf.bounds.width)
    pdf.move_down 20

    pdf.text "T-Shirt Sizes - Full List", size: 8, style: :bold
    pdf.move_down 2

    tshirt_table_data = [["", "Name", "Role", "T-Shirt Size"]]
    @attendees.select { |t| t.person }
              .sort_by { |t| t.person.first_name.to_s }
              .each do |t|
                tshirt_table_data << ["", t.person.full_name, t.person.role, t.person.tshirt_size || "N/A"]
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

    pdf.move_down 30
    pdf.start_new_page
    pdf.text "Uniform Summary Grid", size: 12, style: :bold
    pdf.move_down 10

    uniform_fields = {
      inferno_bottom_skirt_size: "Inferno Bottom Skirt Size",
      inferno_bottom_shorts_size: "Inferno Bottom Shorts Size",
      inferno_top_polo_size: "Inferno Top Polo Size",
      inferno_top_vneck_size: "Inferno Top V-Neck Size"
    }

    people = @attendees.map(&:person).compact

    all_sizes = people.flat_map { |p| uniform_fields.keys.map { |f| p.send(f).to_s.strip.presence } }
                      .compact.uniq.sort

    common_order = %w[XXS XS S M L XL XXL XXXL]
    ordered_sizes = (common_order & all_sizes) + (all_sizes - common_order)

    header_row = ["Item"] + ordered_sizes

    summary_rows = uniform_fields.map do |field, label|
      counts = people.group_by { |p| p.send(field).to_s.strip.presence || "N/A" }
                     .transform_values(&:count)
      [label] + ordered_sizes.map { |size| counts[size] || 0 }
    end

    uniform_summary_table = [header_row] + summary_rows

    pdf.table(uniform_summary_table, header: true, cell_style: { size: 8 }) do
      row(0).font_style = :bold
      row(0).background_color = "CCCCCC"
      columns(0).font_style = :bold
      columns(1..-1).width = 30
      columns(1..-1).align = :right
    end

    pdf.move_down 20

    pdf.text "Uniform Sizes (Umpires Only)", size: 10, style: :bold
    pdf.move_down 4

    uniform_table_data = [["Name", "Role", "Skirt", "Shorts", "Polo", "V-Neck"]]
    @attendees.select { |t| t.role.to_s.include?("Umpire") && t.person }
              .sort_by { |t| t.person.first_name.to_s }
              .each do |t|
                p = t.person
                uniform_table_data << [
                  p.full_name,
                  t.role,
                  p.inferno_bottom_skirt_size || "N/A",
                  p.inferno_bottom_shorts_size || "N/A",
                  p.inferno_top_polo_size || "N/A",
                  p.inferno_top_vneck_size || "N/A"
                ]
              end

    if uniform_table_data.length > 1
      pdf.table(uniform_table_data, header: true, row_colors: ["F0F0F0", "FFFFFF"], cell_style: { size: 9 }) do
        row(0).font_style = :bold
        row(0).background_color = "CCCCCC"
        columns(0).width = 150
        columns(1).width = 80
        columns(2..5).width = 50
      end
    else
      pdf.text "No umpire uniform data found.", size: 10, style: :italic
    end

    pdf.render
  end
  
end
