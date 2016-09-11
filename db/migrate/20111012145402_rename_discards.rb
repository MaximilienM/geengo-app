class RenameDiscards < ActiveRecord::Migration
  def change
    rename_table :employees_import_discards, :import_discards
    rename_column :import_discards, :email, :identifier
    rename_column :import_discards, :employees_import_id, :import_id

    add_index :import_discards, :import_id
  end
end
