class AddPolymorphicAssociationToServices < ActiveRecord::Migration
  def change
    rename_column :services, :infrastructure_id, :purchasable_id
    add_column :services, :purchasable_type, :string
  end
end
