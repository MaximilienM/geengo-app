class AddZipCodeAndCityForAddress < ActiveRecord::Migration
  def change
    change_column :users, :address, :string
    add_column :users, :zip_code, :string
    add_column :users, :city, :string
  end
end
