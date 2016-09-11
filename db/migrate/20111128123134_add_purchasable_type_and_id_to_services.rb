class AddPurchasableTypeAndIdToServices < ActiveRecord::Migration
  def change
    add_column :services, :purchasable_type_and_id, :string
  end
end
