class Firm < ActiveRecord::Base

  # Associations
  ##############

  has_one :work_council, :dependent => :destroy

  has_many :employees, :dependent => :destroy
  has_many :domains, :dependent => :delete_all
  has_many :sport_communities, :dependent => :destroy
  has_many :sports, :through => :sport_communities, :after_remove => :destroy_orphan_sport_community_memberships
  has_many :work_council_groups, :through => :work_council, :source => "groups"
  has_many :communities_events, :through => :sport_communities, :source => :events

  # Validations
  #############

  validates :name, :presence => true, :uniqueness => true

  # Callbacks
  ###########

  after_create Proc.new {create_work_council}
  after_create Proc.new {domains.create(:name => "domain-for-firm#{id}.com") if domains.all.size.zero?}

  # Instance methods
  ##################

  mount_uploader :logo, FirmLogoUploader

  # Protected methods
  ###################

  protected

  # When a sport community is DELETED with the firm.sport_ids=() method
  # the destroy method is not called on it, hence creating orphan sport_community_memberships
  #
  # This methods destroys those orphan sport_community_memberships
  def destroy_orphan_sport_community_memberships(sport)
    SportCommunityMembership.includes(:sport_community).find_all {|scm| scm.sport_community.nil? }.each(&:destroy)
  end

end