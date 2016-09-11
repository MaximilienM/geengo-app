class AddNameToWorkCouncils < ActiveRecord::Migration
  def change
    add_column :work_councils, :name, :string
    WorkCouncil.all.each(&:save)
  end
end
