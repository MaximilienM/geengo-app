class CreateEmployees < ActiveRecord::Migration
  def change
    create_table :employees do |t|
      t.integer :firm_id
      t.string :email
      t.string :department
      t.timestamps
    end
  end
end
