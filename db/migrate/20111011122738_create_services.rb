class CreateServices < ActiveRecord::Migration
  def change
    create_table :services do |t|
      t.string :name
      t.belongs_to :infrastructure

      t.timestamps
    end
    add_index :services, :infrastructure_id
  end
end
