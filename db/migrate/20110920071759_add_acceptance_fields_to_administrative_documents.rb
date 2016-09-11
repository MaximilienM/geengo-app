class AddAcceptanceFieldsToAdministrativeDocuments < ActiveRecord::Migration
  def change
    add_column :administrative_documents, :accepted, :boolean, :null => false, :default => false
    add_column :administrative_documents, :valid_until, :date
  end
end
