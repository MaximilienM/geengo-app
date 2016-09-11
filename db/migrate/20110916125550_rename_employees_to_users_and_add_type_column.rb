class RenameEmployeesToUsersAndAddTypeColumn < ActiveRecord::Migration
  def change
    drop_table :users
    rename_table :employees, :users
    add_column :users, :type, :string
  end
end
