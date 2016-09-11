class AddLatitudeLongitudeToInfrastructures < ActiveRecord::Migration
  def change
    add_column :infrastructures, :latitude, :float
    add_column :infrastructures, :longitude, :float
  end
end
