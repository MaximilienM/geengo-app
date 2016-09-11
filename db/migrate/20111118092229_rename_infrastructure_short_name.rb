class RenameInfrastructureShortName < ActiveRecord::Migration
  def change
    rename_column :infrastructures, :short_name, :backoffice_name
  end

end
