class AttachInfraToAdmin < ActiveRecord::Migration
  def change
    add_column :users, :infrastructure_id, :integer
    add_index :users, :infrastructure_id
  end
end
