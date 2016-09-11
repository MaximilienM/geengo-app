class AddSortColumnToWorkCouncilGroup < ActiveRecord::Migration
  def up
    add_column :work_council_groups, :firm_and_name, :string

    WorkCouncilGroup.all.each do |group|
      group.update_attribute(:firm_and_name, [group.firm.name.downcase, group.name.downcase].join('_'))
    end

    change_column :work_council_groups, :firm_and_name, :string, :null => false
    add_index :work_council_groups, :firm_and_name
  end

  def down
    remove_column :work_council_groups, :firm_and_name
  end
end
