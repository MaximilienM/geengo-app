class CreateDomains < ActiveRecord::Migration
  def change
    create_table :domains do |t|
      t.string :name
      t.integer :firm_id
      t.timestamps
    end
    
    add_index :domains, :firm_id
    add_index :domains, :name, :unique => true
    
    remove_column :firms, :domain
  end
end
