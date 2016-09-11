class RemoveCategoryForInfrastructuresAndEvents < ActiveRecord::Migration
  def change
    remove_column :infrastructures, :category
    remove_column :events, :category
  end
end
