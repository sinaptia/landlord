class CreateTenantConnection < ActiveRecord::Migration[6.0]
  def change
    create_table :tenant_connection, force: :cascade do |t|
      t.string :database
      t.integer :timeout
      t.string :adapter
      t.string :schema_search_path
      t.string :username
      t.string :password
      t.string :host
      t.string :port
      t.string :migrations_paths, default: 'db/tenant_migrate'
      t.boolean :database_owner, default: false
      t.references :tenant, foreign_key: true
      t.datetime :created_at, precision: 6, null: false
      t.datetime :updated_at, precision: 6, null: false
    end
  end
end
