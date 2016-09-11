RailsAdmin::Config::Fields.register_factory do |parent, properties, fields|
  model = parent.abstract_model.model
  if defined?(::CarrierWave) && model.kind_of?(CarrierWave::Mount) && model.uploaders.include?(properties[:name])
    type = properties[:name] =~ /image|picture|thumb|logo/ ? :carrier_wave_image : :carrier_wave_file
    fields << RailsAdmin::Config::Fields::Types.load(type).new(parent, properties[:name], properties)
    true
  else
    false
  end
end