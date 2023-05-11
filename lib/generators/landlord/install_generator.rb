require "rails/generators"
require "rails/generators/active_record"

module Landlord
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      source_root File.expand_path("templates", __dir__)

      def copy_migration_files
        migration_template "create_tenants.rb", "db/migrate/create_tenants.rb"
        migration_template "create_tenant_connections.rb", "db/migrate/create_tenant_connections.rb"
      end

      def create_migrate_tenants_dir
        create_file "db/migrate_tenants/.keep"
      end
    end
  end
end
