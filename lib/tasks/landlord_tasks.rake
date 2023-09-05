require "active_record"

namespace :db do
  # Dumps the public schema in the ruby format as reference
  task ruby_public_dump: :load_config do
    db_config = ActiveRecord::Base.connection_db_config
    ActiveRecord::Tasks::DatabaseTasks.dump_schema(db_config, :ruby)
  end

  namespace :tenants do
    desc "Migrate the tenants database (options: VERSION=x, VERBOSE=false, SCOPE=blog)"
    task migrate: :load_config do
      original_db_config = ActiveRecord::Base.connection_db_config
      ask_again = true
      TenantConnection.order(:id).all.map(&:config).each_with_index do |db_config, index|
        puts "Migrating #{db_config[:schema_search_path]}... "

        # Check in the case tenancy_connection were not localized
        ask_again = check_env_matching_db_configuration!(original_db_config, db_config) if ask_again

        # Migrate
        ActiveRecord::Base.establish_connection(db_config)
        ActiveRecord::Tasks::DatabaseTasks.migrate

        # Use first tenancy_connection for the schema dump
        next unless index.zero?
        db_config[:name] = "tenants"
        ActiveRecord::Tasks::DatabaseTasks.dump_schema(ActiveRecord::DatabaseConfigurations::HashConfig.new(Rails.env, "primary", db_config), :ruby)
      end
    ensure
      ActiveRecord::Base.establish_connection(original_db_config)
    end

    desc "Rolls the schema back to the previous version (specify steps w/ STEP=n)"
    task rollback: :load_config do
      original_db_config = ActiveRecord::Base.connection_db_config
      ask_again = true
      TenantConnection.all.map(&:config).each_with_index do |db_config, index|
        puts "Rollbacking #{db_config[:schema_search_path]}... "

        # Check in the case tenancy_connection were not localized
        ask_again = check_env_matching_db_configuration!(original_db_config, db_config) if ask_again

        # Migrate
        ActiveRecord::Base.establish_connection(db_config)
        ActiveRecord::Base.connection.migration_context.rollback(1)

        # Use first tenancy_connection for the schema dump
        next unless index.zero?
        db_config[:name] = "tenants"
        ActiveRecord::Tasks::DatabaseTasks.dump_schema(OpenStruct.new(db_config), :ruby)
      end
    ensure
      ActiveRecord::Base.establish_connection(original_db_config)
    end
  end
end

# Invoke these tasks after the migration
Rake::Task["db:migrate"].enhance do
  Rake::Task["db:tenants:migrate"].invoke
  Rake::Task["db:ruby_public_dump"].invoke
end

# Handles mismatches between env db and tenant db and returns if this should be run again
def check_env_matching_db_configuration!(env_config, tenancy_config)
  return false if ENV["AWS_ENV_NAME"] == "production"

  env_db_host = env_config.configuration_hash[:host]
  tenant_db_host = tenancy_config[:host]
  return true if env_db_host == tenant_db_host

  extra_databases_in_staging_and_qa_hosts = []
  if (ENV["AWS_ENV_NAME"] == "staging" || ENV["AWS_ENV_NAME"] == "qa") && !extra_databases_in_staging_and_qa_hosts.include?(tenant_db_host)
    abort "Remember to run bundle exec rake tenants:localize_connections or add #{tenant_db_host} to 'extra_databases_in_staging_and_qa_hosts'"
  end

  final_decision = false
  until final_decision
    puts
    puts "This connection doesn't match this env main DB."
    puts "Maybe this is a db-level tenant or maybe you forgot to run tenants:localize_connections"
    puts "Do you want to abort?"
    puts "  * Y: abort, mb :$"
    puts "  * N: continue"
    puts "  * T: Show me the tenant connection db config"
    puts "  * M: Show me the main connection db config from this env"
    puts "  * D: continue and don't ask again"
    option = gets.chomp
    exit if option == "Y"
    ask_again = option != "D"

    if option == "Y" || option == "N" || option == "D"
      final_decision = true
    elsif option == "T"
      puts "Printing tenancy_connection db config..."
      puts tenancy_config
      sleep(1)
    elsif option == "M"
      puts "Printing env main connection db config..."
      puts env_config.configuration_hash
      sleep(1)
    else
      puts "That's not a valid option, try again."
    end
  end

  ask_again
end
