class CreateSportCommunities < ActiveRecord::Migration
  def change
    create_table :sport_communities do |t|
      t.belongs_to :firm, :null => false
      t.belongs_to :sport, :null => false

      t.timestamps
    end
    add_index :sport_communities, :firm_id
    add_index :sport_communities, :sport_id
  end
end
