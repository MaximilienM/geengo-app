class AddUniqIndexOnGroupsNameAndWorkCouncilId < ActiveRecord::Migration
  def change
    add_index :work_council_groups, [:work_council_id, :name], :unique => true
  end
end