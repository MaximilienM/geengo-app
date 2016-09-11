class AddLogoToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :logo, :string
  end
end
