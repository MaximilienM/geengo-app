class RemoveFirmAndNameFromWorkCouncilGroups < ActiveRecord::Migration
  def change
    remove_column :work_council_groups, :firm_and_name
  end
end
