class CreateWorkCouncils < ActiveRecord::Migration
  def change
    create_table :work_councils do |t|
      t.integer :firm_id
      t.decimal :annual_discount_ceiling, :default => 0
      t.timestamps
    end

    add_index :work_councils, :firm_id
  end
end
