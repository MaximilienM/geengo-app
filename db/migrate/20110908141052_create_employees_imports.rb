class CreateEmployeesImports < ActiveRecord::Migration
  def change
    create_table :employees_imports do |t|
      t.integer :employees_created_count
      t.integer :employees_updated_count
      t.timestamps
    end
  end
end