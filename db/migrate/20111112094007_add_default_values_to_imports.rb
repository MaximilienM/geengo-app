class AddDefaultValuesToImports < ActiveRecord::Migration
  def up
    change_column :imports, :created_count, :integer, :default => 0
    change_column :imports, :updated_count, :integer, :default => 0
  end
  
  def down
    change_column :imports, :created_count, :integer, :default => nil
    change_column :imports, :updated_count, :integer, :default => nil    
  end
  
end
