module RailsAdmin::Config::Fields::Types

  class CarrierWaveImage < CarrierWaveFile

    RailsAdmin::Config::Fields::Types.register(self)

    register_instance_option(:partial) do
      :form_carrier_wave_image
    end
  end

end