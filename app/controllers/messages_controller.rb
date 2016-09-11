class MessagesController < FrontController

  def create
    @message = current_employee.messages.create params[:message]
    @message.parent.touch if @message.parent

    redirect_to request.env["HTTP_REFERER"]
  end

end
