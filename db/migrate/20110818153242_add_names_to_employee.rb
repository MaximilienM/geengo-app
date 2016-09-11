class AddNamesToEmployee < ActiveRecord::Migration
  def change
    change_table :employees do |t|
      t.string :first_name
      t.string :last_name
    end
  end
end
