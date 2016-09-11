class ForceFirmIdOnWorkCouncils < ActiveRecord::Migration
  def up
    change_column :work_councils, :firm_id, :integer, :null => false
  end

  def down
    change_column :work_councils, :firm_id, :integer, :null => true
  end
end
