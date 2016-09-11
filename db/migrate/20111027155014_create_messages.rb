class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.belongs_to :sport_community
      t.belongs_to :employee
      t.text :content

      t.timestamps
    end

    add_index :messages, :sport_community_id
    add_index :messages, :employee_id
  end
end
