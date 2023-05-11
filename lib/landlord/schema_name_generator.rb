module Landlord
  module SchemaNameGenerator
    # The schema name has some restrictions - cant start with number, pg, etc
    # See: https://dba.stackexchange.com/questions/45589/what-are-the-valid-formats-of-a-postgresql-schema-name
    # Prefix with tenant_ resolves all these issues
    def self.generate(name)
      create_uniq_name("tenant_#{name.parameterize.underscore}")
    end

    private_class_method

    def self.create_uniq_name(name)
      similar_schemas_names = get_all_with_same_name name
      if similar_schemas_names.size > 0
        next_num = similar_schemas_names.max_by { |name| name.scan(/\d+/) }.scan(/\d+/).first.nil? ? 1 : similar_schemas_names.max_by { |name| name.scan(/\d+/) }.scan(/\d+/).first.to_i + 1
        return "#{name}_#{next_num}"
      end
      name
    end

    def self.get_all_with_same_name(name)
      TenantConnection.where("schema_search_path LIKE ?", "#{name}%").pluck(:schema_search_path)
    end
  end
end
