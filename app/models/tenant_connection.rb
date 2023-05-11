class TenantConnection < LandlordRecord
  belongs_to :tenant

  def shard_name
    Landlord.shard_name(config)
  end

  def config
    hash = attributes.symbolize_keys.except(:id, :created_at, :updated_at, :database_owner, :default_db_name, :default_env_name, :customer_id).compact_blank

    hash[:pool] = ENV.fetch("RAILS_MAX_THREADS", 5)
    hash[:port] = hash[:port].to_i if hash[:port]
    hash
  end

  def self.create_from!(from_env_name:, from_db_name:, **new_attributes)
    defaults = ActiveRecord::Base.configurations.configs_for(env_name: from_env_name, name: from_db_name).configuration_hash
    tenant_options = new_attributes.symbolize_keys

    # public is not a valid schema name
    raise if tenant_options[:schema_search_path] == "public"

    create!(**defaults.merge(tenant_options))
  end

  def self.current
    current_connection = Landlord.current_connection

    # WEIRD BUG: Needs more research
    # For some weird reason Rails returns port as a string here
    # but usually Rails returns port as a integer.
    # The reason is a mistery at the moment.
    current_connection[:port] = current_connection[:port].to_i if current_connection[:port]

    Landlord.switch Landlord.main_connection do
      all.detect do |tenancy_connection|
        tenancy_connection.config == current_connection
      end
    end
  end

  def self.all_configurations
    all.map(&:config)
  end
end
