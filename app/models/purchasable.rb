module Purchasable

  def self.included(receiver)

    receiver.class_eval do
      has_many :services, :dependent => :destroy, :inverse_of => :purchasable, :as => :purchasable
      accepts_nested_attributes_for :services, :reject_if => Proc.new { |attribs|
        s = attribs.symbolize_keys[:id].present? ? Service.find(attribs.symbolize_keys[:id]) : Service.new
        s.attributes = attribs
        s.name.blank? && s.sub_services.size.zero?
      }
      attr_accessible :services_attributes
    end

  end
end