class Tenant < ApplicationRecord
    has_one :tenant_connection, dependent: :destroy

    include SchemaNameGenerator

    after_create_commit :create_tenant_connection
  
    def self.current
      current_tenant_connection = TenantConnection.current

      TenancyManager.switch_to_main do
        tenant.find_by(tenancy_connection: current_tenant_connection)
      end
    end
  
    def create_tenant_connection
      @tenancy_connection = TenantConnection.create_from!(from_env_name: Rails.env, from_db_name: "primary", schema_search_path: schema_name_override || SchemaNameGenerator.generate(name), tenant: self)
      TenancyManager.create_tenant(@tenancy_connection.config)
      ApplicationRecord.fetch_db_connections
  
      ## Hot restart puma
      unless Rails.env.test?
        pid = File.read(".pumactl_pid").to_i
        Process.kill("SIGUSR2", pid)
      end
    end
end
  