class AddMissingAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :photo, :string
    add_column :users, :date_of_birth, :date
    add_column :users, :address, :text
    add_column :users, :mobile, :string
  end
end
