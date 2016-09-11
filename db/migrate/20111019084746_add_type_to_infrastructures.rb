class AddTypeToInfrastructures < ActiveRecord::Migration
  def change
    add_column :infrastructures, :type, :string
  end
end
