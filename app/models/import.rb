# encoding : utf-8

class Import < ActiveRecord::Base

  attr_accessor :file

  # Validations
  #############

  validates :file, :presence => true
  validate :file_content_type, :unless => Proc.new {["text/csv", "text/html"].include? file.try(:content_type)}

  # Associations
  ##############

  has_many :discards, :class_name => "ImportDiscard", :dependent => :destroy

  # Callbacks
  ###########

  before_save :process_file

  # Instance methods
  ##################

  # Returns the Model we are going to use to create the imported objects
  def imported_class
    raise "Import class is abstract. Please subclass it" if self.class == Import
    self.class.to_s.gsub('sImport', "").constantize
  end

  protected

  def process_file

    @records = []

    # HACK : abstraction needed here
    @identifier = imported_class == Employee ? :email : :name

    self.file.to_attributes.each do |attributes|
      @records << build_record(attributes)
    end

    save_records

  end

  # Based on the @identifier and the attributes
  # Finds an existing record or initializes a new one
  #
  # Then nests the attributes and assigns the result to the record
  #
  # HACK : if record is an Employee, also sets its password with its email to be sure record is valid
  #
  # Returns the record
  def build_record(attributes)
    # Find or initialize a new record
    imported_record = imported_class.where(@identifier => attributes[@identifier]).first || imported_class.new

    # Set its attributes after nesting them
    imported_record.attributes = imported_record.nest_attributes(attributes)

    # HACK for Employee. We set the password with the email
    if !imported_record.persisted? && imported_record.is_a?(Employee)
      imported_record.password = imported_record.email
    end

    imported_record
  end

  # Cycle on each record for the import
  #
  # If this is a record update (record was already persisted), update the updated_count
  # If this is creation (record was not persisted), update the created_count
  #
  # If the record is invalid, build a new discard
  def save_records
    @records.each do |record|

      if record.valid?
        record.persisted? ? self.updated_count += 1 : self.created_count += 1
        record.save
      else
        self.discards.build(
          :identifier => record.send(@identifier),
          :description => ImportDiscard.description_for(record)
        )
      end

    end
  end

  def file_content_type
    errors.add :file, "doit être au format CSV ou HTML"
  end

end