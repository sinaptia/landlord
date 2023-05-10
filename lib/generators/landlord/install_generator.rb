require 'rails/generators/active_record'

module Landlord
  module Generators
    class InstallGenerator < ActiveRecord::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_migration_files
        migration_template 'create_tenants.rb', 'db/migrate/create_tenants.rb'
        migration_template 'create_tenant_connection.rb', 'db/migrate/create_tenant_connection.rb'
      end

      def generate_models
        copy_file 'tenant.rb', 'app/models/tenant.rb'
        copy_file 'tenant_connection.rb', 'app/models/tenant_connection.rb'
      end
    end
  end
end
