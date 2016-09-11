class StiForImports < ActiveRecord::Migration

  def change
    # rename the table and columns
    rename_table(:employees_imports, :imports)
    rename_column :imports, :employees_created_count, :created_count
    rename_column :imports, :employees_updated_count, :updated_count

    # add the sti column
    add_column :imports, :type, :string

    # update all previous records
    t = Import.arel_table
    stmt = Import.unscoped.arel.compile_update({t[:type] => "EmployeesImport"})
    Import.connection.update stmt
  end

end