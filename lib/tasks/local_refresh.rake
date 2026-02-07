namespace :db do
  desc "Refresh local development DB from latest Heroku dump"
  task local_refresh: :environment do
    unless Rails.env.development?
      abort "❌ db:local_refresh can only be run in development"
    end

    dump_file = Rails.root.join("latest.dump")

    unless File.exist?(dump_file)
      abort "❌ latest.dump not found in project root"
    end

    db_name = "netball_usa_development"

    puts "⚠️  This will ERASE and RESTORE #{db_name}"
    puts "➡️  Using dump: #{dump_file}"
    puts "--------------------------------------"

    # Drop & create DB
    system("rails db:drop db:create") || abort("❌ DB drop/create failed")

    # Restore dump
    restore_cmd = <<~CMD
      pg_restore
        --verbose
        --clean
        --no-owner
        --no-acl
        -d #{db_name}
        #{dump_file}
    CMD

    system(restore_cmd.squish) || abort("❌ pg_restore failed")

    # Run migrations
    system("rails db:migrate") || abort("❌ db:migrate failed")

    puts "✅ Local DB refresh complete"
  end
end
