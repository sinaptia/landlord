class LandlordRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.fetch_db_connections
    connections = []

    role = :writing
    default_shard = :primary

    handler = lookup_connection_handler(role.to_sym)
    self.connection_class = true

    # Default connection
    db_config, owner_name = resolve_config_for_connection(default_shard)
    connections << handler.establish_connection(db_config, owner_name: owner_name, role: role, shard: default_shard)

    # Stored in the db connections
    begin
      db_stored_connections_configurations = ActiveRecord::Base.connection.execute("SELECT database, timeout, adapter, schema_search_path, username, password, host, port, migrations_paths FROM tenants_connection").to_a
      db_stored_connections_configurations.each { |config| config["pool"] = ENV.fetch("RAILS_MAX_THREADS", 5) }
      db_stored_connections_configurations.each do |connection_configuration|
        connection_configuration = connection_configuration.symbolize_keys
        connections << handler.establish_connection(connection_configuration, owner_name: owner_name, role: role, shard: TenancyManager.shard_name(connection_configuration))
      end
    rescue
      # In migrations, we might not have tenants_connection, it is not neccessary to load them anyways
    end

    connections
  end

  # TODO: originally this should go in ApplicationRecord. By extracting this functionality (see tenant.rb:19) into this class to share across models of this gem, this doesn't work.
  # why we need it?
  # fetch_db_connections
end
