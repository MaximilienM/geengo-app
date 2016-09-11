class CreateAdministrativeDocuments < ActiveRecord::Migration
  def change
    create_table :administrative_documents do |t|
      t.belongs_to :sport_community_membership, :null => false
      t.string :document
      t.string :kind
      t.timestamps
    end

    add_index :administrative_documents, :sport_community_membership_id
  end
end
