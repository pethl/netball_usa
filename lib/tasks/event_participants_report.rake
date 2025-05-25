namespace :reports do
  desc "Generate report of events with participants sorted by educator first name"
  task events_with_educators: :environment do
    output_path = "lib/tasks/event_participants_report.txt"

    File.open(output_path, "w") do |file|
      Event.includes(event_participants: :netball_educator)
           .order(:date).find_each do |event|

        file.puts "📅 Event: #{event.name} - #{event.date.strftime('%Y-%m-%d')}"

        educators = event.event_participants.map(&:netball_educator).compact
        educators.sort_by!(&:first_name)

        if educators.any?
          educators.each do |educator|
            full_name = "#{educator.first_name} #{educator.last_name}"
            file.puts " - #{full_name}"
          end
        else
          file.puts " - No participants"
        end

        file.puts ""
      end
    end

    puts "✅ Report generated at #{output_path}"
  end
end

