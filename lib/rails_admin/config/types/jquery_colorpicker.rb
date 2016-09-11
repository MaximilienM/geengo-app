module RailsAdmin::Config::Fields::Types

  class JqueryColorpicker < RailsAdmin::Config::Fields::Types::String

    RailsAdmin::Config::Fields::Types.register(self)

    register_instance_option(:partial) do
      :jquery_colorpicker
    end
    
    register_instance_option(:pretty_value) do
      "<div style='width: 45px; height: 25px; background-color: #{value}'>&nbsp;</div>".html_safe
    end
  end

end