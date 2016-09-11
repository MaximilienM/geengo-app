class AddNameToWorkCouncilGroups < ActiveRecord::Migration
  def change
    add_column :work_council_groups, :name, :string
  end
end
