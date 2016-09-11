class UniquenessOnWorkCouncilFirmId < ActiveRecord::Migration
  def up
    remove_index :work_councils, :firm_id
    add_index :work_councils, :firm_id, :unique => true
  end

  def down
    remove_index :work_councils, :firm_id
    add_index :work_councils, :firm_id
  end
end
