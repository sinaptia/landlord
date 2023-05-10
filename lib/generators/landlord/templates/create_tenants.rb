class CreateTenants < ActiveRecord::Migration[6.0]
    def change
      create_table :tenants, force: :cascade do |t|
        t.string :name

        t.timestamps
      end
    end
  end
  