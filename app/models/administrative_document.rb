class AdministrativeDocument < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :sport_community_membership

  # Validations
  #############

  validates :sport_community_membership_id, :presence => true
  validates :document, :presence => true

  # Instance methods
  ##################

  mount_uploader :document, AdministrativeDocumentUploader

  def name
    "#{document_identifier} (#{kind})"
  end
  
  def availables_kinds
    I18n.t("activerecord.administrative_documents.kinds").keys.map do |key|
      [I18n.t("activerecord.administrative_documents.kinds.#{key}"), key]
    end.sort
  end
  
  def translated_kind
    return unless kind.present?
    I18n.t("activerecord.administrative_documents.kinds.#{kind}")
  end

end