class GeocodeNotGeocoded

  @queue = "*"

  # Geocode all not_geocoded object of the class
  def self.perform(class_name)

    klass = class_name.constantize

    return unless klass.geocoder_options

    klass.not_geocoded.each do |object|
      object.geocode
      object.save
    end
  end

end