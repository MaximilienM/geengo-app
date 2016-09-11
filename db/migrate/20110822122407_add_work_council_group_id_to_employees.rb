class AddWorkCouncilGroupIdToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :work_council_group_id, :integer
    add_index :employees, :work_council_group_id
  end
end
