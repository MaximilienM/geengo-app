class CreateWorkCouncilGroups < ActiveRecord::Migration
  def change
    create_table :work_council_groups do |t|
      t.belongs_to :work_council
      t.float :discount_percentage, :default => 0
      t.decimal :annual_discount_ceiling, :default => 0
      t.decimal :transaction_discount_ceiling, :default => 0

      t.timestamps
    end
    add_index :work_council_groups, :work_council_id
  end
end
