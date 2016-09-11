class AddNameToSportCommunityMemberships < ActiveRecord::Migration
  def change
    add_column :sport_community_memberships, :name, :string, :null => false, :default => ""
    SportCommunityMembership.all.each(&:save)
  end
end
