class AddAddressToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :address, :text
  end
end
