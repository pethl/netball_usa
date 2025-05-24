namespace :netball_educators do
  desc "Check emails from a fixed input file against the netball_educators table"
  task check_emails_from_file: :environment do
    require 'csv'

    input_path = "lib/tasks/input_emails.txt"
    output_path = "lib/tasks/netball_educator_email_check_results.txt"

    unless File.exist?(input_path)
      puts "❌ File not found: #{input_path}"
      exit
    end

    raw_emails = File.readlines(input_path).flat_map { |line| line.strip.split(',') }
    emails = raw_emails.map(&:strip).reject(&:empty?).uniq

    puts "\n🔍 Checking #{emails.size} unique email(s)...\n\n"

    existing_emails = NetballEducator.where(email: emails).pluck(:email)
    missing_emails = emails - existing_emails

    File.open(output_path, "w") do |f|
      f.puts "✅ Existing Emails (#{existing_emails.size}):"
      existing_emails.sort.each { |email| f.puts email }

      f.puts "\n❌ Missing Emails (#{missing_emails.size}):"
      missing_emails.sort.each { |email| f.puts email }

      f.puts "\n📊 Summary:"
      f.puts "Total provided: #{emails.size}"
      f.puts "Existing: #{existing_emails.size} (#{((existing_emails.size.to_f / emails.size) * 100).round(2)}%)"
      f.puts "Missing: #{missing_emails.size} (#{((missing_emails.size.to_f / emails.size) * 100).round(2)}%)"
    end

    puts "✅ Done! Results saved to: #{output_path}"
  end
end
