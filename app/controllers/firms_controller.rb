class FirmsController < FrontController

  respond_to :css

  layout false

  def show
    @firm = current_employee.firm

    # This code is inspired by Sprockets::Context#evaluate
    # lib/sprockets/context.rb:161 in Sprockets 2.0.3
    pathname = Rails.root + "app/views/firms/show.css.scss.erb"
    result = File.read pathname

    [Tilt::ERBTemplate, Tilt::ScssTemplate].each do |processor|
      template = processor.new(pathname.to_s) { result }
      result = template.render(self, {:firm => @firm})
    end

    render :text => result

  end

end
