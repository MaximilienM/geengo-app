class AddColorsToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :basecolor_color, :string
    add_column :firms, :complement_color, :string
  end
end
