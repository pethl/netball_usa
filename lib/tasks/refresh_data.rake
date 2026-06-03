# lib/tasks/refresh_data.rake

namespace :db do
  desc "Backup Heroku DB, download, restore to local dev/test, migrate both, clean up, then start server"
  task :refresh do
    app = "netball-america"
    dump = "latest.dump"
    restore_list = "restore.list"

    dev_db = "netball_usa_development"
    test_db = "netball_usa_test"

    puts "🧹 Cleaning up old backup/list files..."
    File.delete(dump) if File.exist?(dump)
    File.delete(restore_list) if File.exist?(restore_list)

    puts "🚀 Capturing Heroku backup..."
    system("heroku pg:backups:capture --app #{app}") ||
      abort("❌ Failed to capture Heroku backup.")

    puts "⬇️ Downloading Heroku backup..."
    system("heroku pg:backups:download --app #{app}") ||
      abort("❌ Failed to download Heroku backup.")

    puts "🧾 Creating filtered restore list..."
    system("pg_restore -l #{dump} | grep -v pg_stat_statements > #{restore_list}") ||
      abort("❌ Failed to create filtered restore list.")

    puts "🧨 Dropping and recreating development database..."
    system("dropdb --if-exists --force #{dev_db}") ||
      abort("❌ Failed to drop development database.")

    system("createdb #{dev_db}") ||
      abort("❌ Failed to create development database.")

    puts "🧨 Dropping and recreating test database..."
    system("dropdb --if-exists --force #{test_db}") ||
      abort("❌ Failed to drop test database.")

    system("createdb #{test_db}") ||
      abort("❌ Failed to create test database.")

    puts "🛠️ Restoring backup into development database..."
    system("pg_restore --verbose --no-acl --no-owner -L #{restore_list} -h localhost -d #{dev_db} #{dump}") ||
      abort("❌ Failed to restore development database.")

    puts "🛠️ Restoring backup into test database..."
    system("pg_restore --verbose --no-acl --no-owner -L #{restore_list} -h localhost -d #{test_db} #{dump}") ||
      abort("❌ Failed to restore test database.")

    puts "🔐 Setting Rails environment metadata for development..."
    system("bin/rails db:environment:set") ||
      abort("❌ Failed to set development environment metadata.")

    puts "🔐 Setting Rails environment metadata for test..."
    system("RAILS_ENV=test bin/rails db:environment:set") ||
      abort("❌ Failed to set test environment metadata.")

    puts "🚚 Running migrations on development..."
    system("bin/rails db:migrate") ||
      abort("❌ Failed to migrate development database.")

    puts "🚚 Running migrations on test..."
    system("RAILS_ENV=test bin/rails db:migrate") ||
      abort("❌ Failed to migrate test database.")

    puts "🧹 Cleaning up backup/list files..."
    File.delete(dump) if File.exist?(dump)
    File.delete(restore_list) if File.exist?(restore_list)

    puts "✅ Development and test databases refreshed from Heroku backup."

    puts "💻 Starting Rails server..."
    exec("bin/rails server")
  end
end