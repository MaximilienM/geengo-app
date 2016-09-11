class CreateSportCommunityMemberships < ActiveRecord::Migration
  def change
    create_table :sport_community_memberships do |t|
      t.belongs_to :employee, :null => false
      t.belongs_to :sport_community, :null => false
      t.string :level

      t.timestamps
    end
    add_index :sport_community_memberships, :employee_id
    add_index :sport_community_memberships, :sport_community_id
  end
end
