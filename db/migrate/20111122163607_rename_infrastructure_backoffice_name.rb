class RenameInfrastructureBackofficeName < ActiveRecord::Migration
  def up
    rename_column :infrastructures, :backoffice_name, :display_name
    change_column :infrastructures, :display_name, :string, :null => false
  end

  def down
    rename_column :infrastructures, :display_name, :backoffice_name
    change_column :infrastructures, :backoffice_name, :string, :null => true
  end
end
