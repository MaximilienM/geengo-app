class AddRankingAndOthersToSportCommunityMemberships < ActiveRecord::Migration
  def change
    add_column :sport_community_memberships, :ranking, :string
    add_column :sport_community_memberships, :licence_number, :string
    add_column :sport_community_memberships, :position, :string
  end
end
