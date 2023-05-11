require "landlord/concern"
require "landlord/engine"
require "landlord/schema_name_generator"

module Landlord
  # Returns the connection configuration of the main connection
  def self.main_connection
    ActiveRecord::Base.configurations.configs_for(env_name: Rails.env, name: "primary").configuration_hash.symbolize_keys.compact_blank
  end

  # Returns true if connected to the main connection
  def self.main_connection?
    current_connection? main_connection
  end

  # Returns the connection configuration of the current connection
  def self.current_connection
    ActiveRecord::Base.connection_db_config.configuration_hash.symbolize_keys.compact_blank
  end

  # Returns true if current connection is equal to the received connection
  def self.current_connection? connection
    current_connection == connection
  end

  # Switchs to main connection in the given block
  # More user friendly option for switching tenants
  # It will only establish a new connection if the given connection is not the current connection
  def self.switch_to_main(&blk)
    if main_connection?
      yield blk
    else
      switch main_connection do
        yield blk
      end
    end
  end

  # Switchs to the tenant tenant connection
  # More user friendly option for switching tenants
  # It will only establish a new connection if the given connection is not the current connection
  def self.switch_to(tenant, &blk)
    if current_connection? tenant.tenant_connection.config
      blk.call(tenant)
    else
      switch tenant.tenant_connection.config do
        blk.call(tenant)
      end
    end
  end

  # Switches to the given connection configuration for the given block
  # More native option for switching tenants
  def self.switch(connection_configuration, &blk)
    ActiveRecord::Base.connected_to(role: :writing, shard: shard_name(connection_configuration)) do
      yield blk
    end
  end

  # Permanent switches
  # Only in development for easier debugging in the
  # terminal as requested by Developers
  if Rails.env.development? || Rails.env.test?
    def self.switch! connection_configuration
      ActiveRecord::Base.establish_connection(connection_configuration)
    end

    def self.switch_to_main!
      ActiveRecord::Base.establish_connection(main_connection)
    end

    def self.switch_to! tenant
      connection = tenant.tenant_connection.config
      return if current_connection? connection
      ActiveRecord::Base.establish_connection(connection)
    end
  end

  # Execute the block in all the given connection configurations
  def self.switch_all(connection_configurations, &blk)
    connection_configurations.map do |connection|
      switch connection do
        yield blk
      end
    end
  end

  def self.switch_to_all(tenants, &blk)
    tenants.map do |tenant|
      switch_to tenant do
        blk.call(tenant)
      end
    end
  end

  # Returns shard_name for a given connection configuration
  def self.shard_name(connection_configuration)
    if main_connection == connection_configuration
      :primary
    else
      "#{connection_configuration[:host] || connection_configuration[:database]}-#{connection_configuration[:schema_search_path]}".to_sym
    end
  end

  # Creates database and/or schema for the given connection
  def self.create_tenant(connection)
    previous_connection = ActiveRecord::Base.connection_db_config
    if !ActiveRecord::Base.connection.class.database_exists? connection
      ActiveRecord::Tasks::DatabaseTasks.create(connection)
    end

    ActiveRecord::Base.establish_connection(connection)
    if connection[:schema_search_path] && !schema_exists?(connection[:schema_search_path])
      create_schema(connection[:schema_search_path])
    end

    ActiveRecord::Tasks::DatabaseTasks.migrate

    ActiveRecord::Base.establish_connection(previous_connection)
  end

  # Drops database and/or schema for the given connection
  def self.drop_tenant(connection, drop_database: true)
    if drop_database
      ActiveRecord::Tasks::DatabaseTasks.drop(connection)
    else
      switch connection do
        drop_schema(connection[:schema_search_path]) if schema_exists? connection[:schema_search_path]
      end
    end
  end

  # Migrates the database or schema in the current connection
  def self.migrate(connection)
    switch connection do
      ActiveRecord::Tasks::DatabaseTasks.migrate
    end
  end

  # Creates a schema
  def self.create_schema(schema_name)
    ActiveRecord::Base.connection.create_schema schema_name
  end

  # Drops a schema
  def self.drop_schema(schema_name)
    ActiveRecord::Base.connection.drop_schema schema_name
  end

  # Returns if received schema name exists
  def self.schema_exists?(name)
    ActiveRecord::Base.connection.schema_exists? name
  end
end
