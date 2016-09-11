class RenameCommentsAttributeOnInfras < ActiveRecord::Migration
  def change
    rename_column :infrastructures, :comments, :other_comments
  end
end
