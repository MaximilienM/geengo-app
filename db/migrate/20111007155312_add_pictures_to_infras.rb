class AddPicturesToInfras < ActiveRecord::Migration

  def up
    add_column :infrastructures, :picture_1, :string
    add_column :infrastructures, :picture_2, :string
    add_column :infrastructures, :picture_3, :string
  end

  def down
    remove_column :infrastructures, :picture_1
    remove_column :infrastructures, :picture_2
    remove_column :infrastructures, :picture_3
  end

end