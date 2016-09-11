class ImportDiscard < ActiveRecord::Base

  # Associations
  ##############

  belongs_to :import

  # Class methods
  ###############

  class << self

    # This methods take a -record- created by Import#build_record and returns the discard description
    def description_for(record)

      description = record.errors.map do |attribute, message|
        [record.class.human_attribute_name(attribute), message].join(' ') unless attribute == :firm_id
      end.join("\n")

    end

  end
end
