class CreateEmployeesImportDiscards < ActiveRecord::Migration
  def change
    create_table :employees_import_discards do |t|
      t.belongs_to :employees_import
      t.string :email
      t.text :description

      t.timestamps
    end
    add_index :employees_import_discards, :employees_import_id
  end
end
