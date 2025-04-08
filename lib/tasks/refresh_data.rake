# lib/tasks/refresh_data.rake
namespace :db do
  desc "Backup Heroku DB, download, restore to local dev and test, and clean up"
  task refresh: :environment do
    puts "🚀 Starting backup from Heroku..."

    system("heroku pg:backups:capture --app netball-america") || abort("❌ Failed to capture backup.")
    puts "✅ Backup captured."

    system("heroku pg:backups:download --app netball-america") || abort("❌ Failed to download backup.")
    puts "✅ Backup downloaded."

    puts "🛠️ Restoring to development database..."
    system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -d netball_usa_development latest.dump") || abort("❌ Failed to restore development database.")
    puts "✅ Development database restored."

    puts "🛠️ Restoring to test database..."
    system("pg_restore --verbose --clean --no-acl --no-owner -h localhost -d netball_usa_test latest.dump") || abort("❌ Failed to restore test database.")
    puts "✅ Test database restored."

    puts "🛠️ reet ENV to test..."
    system("RAILS_ENV=test bundle exec rails db:environment:set") || abort("❌ Failed to set environment to test.")
     puts "✅ ENV SET TEST."

    puts "🧹 Cleaning up backup file..."
    File.delete("latest.dump") if File.exist?("latest.dump")
    puts "✅ Backup file deleted."

    puts "💻 Starting Rails server..."
    exec("bin/rails server")
  end
end
