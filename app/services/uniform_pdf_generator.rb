# app/services/uniform_pdf_generator.rb
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
    safe_w = pdf.bounds.width - 10

    # ===== Page 1 =====
    # Logos (top left & top right)
    pdf.image "#{Rails.root}/app/assets/images/Netball_America_Logo.png",
              at: [0, pdf.cursor], width: 80
    pdf.image "#{Rails.root}/app/assets/images/US Open 2025 Logo_Small.png",
              at: [pdf.bounds.width - 80, pdf.cursor], width: 80
    pdf.move_down 60

    # Title
    pdf.text "Uniforms & T-Shirts Sheet", size: 16, style: :bold, align: :center
    pdf.move_down 6
    pdf.text "Print Date: #{Date.today.strftime('%b %d, %Y')}", size: 8, align: :center
    pdf.move_down 16

    # --- T-Shirt Sizes Summary (fixed width, centered) ---
    ordered = ["XS", "Small", "Medium", "Large", "XL", "2XL", "3XL", "4XL", "Not Given"]
    size_counts = @attendees.group_by { |t| (t.person&.tshirt_size.to_s.strip.presence || "Not Given") }
                            .transform_values(&:count)
    rows = ordered.map { |s| [s, size_counts[s] || 0] }
    total = rows.sum { |_, c| c.to_i }
    summary_data = [["T-Shirt Size", "Count"]] + rows + [["Total", total]]

    pdf.text "T-Shirt Sizes Summary", size: 12, style: :bold, align: :center
    pdf.move_down 6

    summary_table_w = 400.0
    summary_x = (pdf.bounds.width - summary_table_w) / 2.0
    pdf.bounding_box([summary_x, pdf.cursor], width: summary_table_w) do
      pdf.table(summary_data,
                width: summary_table_w,
                column_widths: [(summary_table_w * 0.6).round(2), (summary_table_w * 0.4).round(2)],
                header: true,
                cell_style: { size: 9, padding: 3, overflow: :shrink_to_fit, min_font_size: 7, inline_format: false }) do
        row(0).font_style = :bold
        row(0).background_color = "DDDDDD"
        columns(1).align = :right
        row(-1).background_color = "DDDDDD" # highlight total row
        row(-1).font_style = :bold
      end
    end

    # --- Missing T-Shirt Sizes (fixed width, centered) ---
    pdf.move_down 14
    pdf.text "Missing T-Shirt Sizes", size: 12, style: :bold, align: :center
    pdf.move_down 6

    missing = [["Name", "Role"]]
    @attendees.select { |t| t.person&.tshirt_size.to_s.strip.blank? }
              .each { |t| missing << [t.person&.full_name || "Unknown", t.person&.role || ""] }
    missing << ["All attendees", "have submitted a size"] if missing.size == 1

    missing_table_w = 400.0
    missing_x = (pdf.bounds.width - missing_table_w) / 2.0
    pdf.bounding_box([missing_x, pdf.cursor], width: missing_table_w) do
      pdf.table(missing,
                width: missing_table_w,
                column_widths: [(missing_table_w * 0.7).round(2), (missing_table_w * 0.3).round(2)],
                header: true,
                cell_style: { size: 9, padding: 3, overflow: :shrink_to_fit, min_font_size: 7, inline_format: false }) do
        row(0).font_style = :bold
        row(0).background_color = "DDDDDD"
      end
    end

    # --- Full list table (full width) ---
    pdf.move_down 14
    pdf.text "T-Shirt Sizes - Full List", size: 11, style: :bold
    pdf.move_down 6

    list_data = [["#", "Name", "Role", "T-Shirt Size"]]
    @attendees.select(&:person)
              .sort_by { |t| t.person.first_name.to_s }
              .each_with_index do |t, i|
                p = t.person
                list_data << [
                  i + 1,
                  p.full_name,
                  p.role,
                  p.tshirt_size.presence || "N/A"
                ]
              end

    w0 = 24.0
    rem = (safe_w - w0).round(2)
    w1 = (rem * 0.55).round(2)
    w2 = (rem * 0.25).round(2)
    w3 = (rem - w1 - w2).round(2)

    pdf.table(list_data,
              width: safe_w,
              column_widths: [w0, w1, w2, w3],
              header: true,
              row_colors: ["F8F8F8", "FFFFFF"],
              cell_style: { size: 8, padding: 2, overflow: :shrink_to_fit, min_font_size: 7, inline_format: false }) do
      row(0).font_style = :bold
      row(0).background_color = "EEEEEE"
      columns(0).align = :right
    end

    pdf.render
  end
end
