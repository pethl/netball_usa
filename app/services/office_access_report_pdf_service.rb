# frozen_string_literal: true

require "prawn"
require "prawn/table"

class OfficeAccessReportPdfService
  NAVY = "243B7B"
  PALE_BLUE = "EAF1FB"
  LIGHT_GREY = "F3F4F6"

  def initialize(report)
    @report = report
  end

  def generate
    Prawn::Document.new(page_layout: :portrait, margin: 32) do |pdf|
      render_title(pdf)
      render_universal_access(pdf)
      render_by_model(pdf)
      render_by_user(pdf)
    end.render
  end

  private

  def render_title(pdf)
    pdf.text "Office User Access Report", size: 22, style: :bold, color: NAVY
    pdf.text "Role 4 (office) users only - Generated #{Time.zone.now.strftime('%d %b %Y at %H:%M')}",
             size: 9,
             color: "555555"
    pdf.move_down 14
  end

  def render_universal_access(pdf)
    section_heading(pdf, "Access for every office user")
    rows = [["Model / area", "Access"]] + OfficeAccessReport::UNIVERSAL_ACCESS
    report_table(pdf, rows, widths: [150, pdf.bounds.width - 150])
    pdf.move_down 16
  end

  def render_by_model(pdf)
    section_heading(pdf, "Selected access by model")
    rows = [["Model / area", "Access", "Office users"]]
    rows += @report.by_model.map do |entry|
      [entry.model_name, entry.access_level, entry.users.map { |user| user_label(user) }.join("\n")]
    end
    report_table(pdf, rows, widths: [135, 180, pdf.bounds.width - 315])
    pdf.move_down 18
  end

  def render_by_user(pdf)
    pdf.start_new_page
    section_heading(pdf, "Access by office user")

    @report.by_user.each do |entry|
      rows = [["Model / area", "Access"]]
      rows += entry.access.map { |access| [access.model_name, access.access_level] }
      rows << ["Selected access", "None"] if entry.access.empty?

      table = build_report_table(
        pdf,
        rows,
        widths: [170, pdf.bounds.width - 170]
      )

      # Allow room for the user's heading and groups as well as the table.
      # Start a fresh page before drawing when the complete block will not fit.
      pdf.start_new_page if pdf.cursor < table.height + 42

      pdf.text user_label(entry.user), size: 12, style: :bold, color: NAVY
      group_names = entry.groups.map(&:name)
      pdf.text "Groups: #{group_names.presence&.join(', ') || 'None'}", size: 8, color: "555555"
      pdf.move_down 4
      table.draw
      pdf.move_down 12
    end
  end

  def section_heading(pdf, text)
    pdf.text text, size: 15, style: :bold, color: NAVY
    pdf.move_down 6
  end

  def report_table(pdf, rows, widths:)
    build_report_table(pdf, rows, widths: widths).draw
  end

  def build_report_table(pdf, rows, widths:)
    pdf.make_table(rows, header: true, width: pdf.bounds.width, column_widths: widths) do |table|
      table.cells.padding = 6
      table.cells.size = 8
      table.row(0).font_style = :bold
      table.row(0).background_color = NAVY
      table.row(0).text_color = "FFFFFF"
      table.rows(1..-1).style(background_color: LIGHT_GREY)
      table.cells.border_color = "D1D5DB"
    end
  end

  def user_label(user)
    return user.full_name if user.account_active?

    "#{user.full_name} (Locked)"
  end
end
