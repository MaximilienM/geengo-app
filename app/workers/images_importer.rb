class ImagesImporter

  @queue = "*"

  def self.perform(class_name)
    class_name.constantize.import_uploaders
  end

end