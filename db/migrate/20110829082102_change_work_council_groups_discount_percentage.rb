class ChangeWorkCouncilGroupsDiscountPercentage < ActiveRecord::Migration
  def up
    change_column :work_council_groups, :discount_percentage, :integer, :null => false, :default => 0
  end

  def down
    change_column :work_council_groups, :discount_percentage, :float, :null => true, :default => 0
  end
end
