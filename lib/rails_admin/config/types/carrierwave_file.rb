module RailsAdmin::Config::Fields::Types
  # Field type that supports CarrierWave file uploads
  class CarrierWaveFile < RailsAdmin::Config::Fields::Types::FileUpload
    
    RailsAdmin::Config::Fields::Types.register(self)
    
    register_instance_option(:partial) do
      :form_carrier_wave_file
    end

    register_instance_option(:formatted_value) do
      # get the value stored in the db e.g. "smiley.png" instead of the files entire path
      # note we need to call `name.to_s` because attributes takes a string and name returns a symbol.
      bindings[:object].attributes[name.to_s]
    end
    
    # register_instance_option(:pretty_value) do
    #   v = bindings[:view]
    #   o = bindings[:object]
    #   uploader = o.send(name)
    #   v.image_tag(uploader.url, :alt => o.send("#{name}_identifier"))
    # end
  end
end