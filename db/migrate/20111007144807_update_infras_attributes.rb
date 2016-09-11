class UpdateInfrasAttributes < ActiveRecord::Migration
  def change
    add_column :infrastructures, :description, :text
    add_column :infrastructures, :category, :string
    add_column :infrastructures, :accessible, :string
    
    rename_column :infrastructures, :full_name, :name
    rename_column :infrastructures, :complementary_informations, :practical_informations
  end

end
