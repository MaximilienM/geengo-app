class CreateSubServices < ActiveRecord::Migration
  def change
    create_table :sub_services do |t|
      t.string :name
      t.belongs_to :service
      t.decimal :price, :default => 0
      t.decimal :discount, :default => 0
      t.text :eligible_conditions

      t.timestamps
    end
    add_index :sub_services, :service_id
  end
end
