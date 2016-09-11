# encoding : utf-8

class AdministrativeDocumentsController < FrontController

  respond_to :html, :json

  def create
    @doc = AdministrativeDocument.new(params[:administrative_document])
    if @doc.save
      redirect_to "/profile/documents", :notice => "Document ajouté"
    else
      render "profiles/documents"
    end
  end
  
  def update
    @doc = AdministrativeDocument.find params[:id]
    
    if @doc.update_attributes(params[:administrative_document])
      respond_with @doc
    end
    
  end
  
  def destroy
    @doc = AdministrativeDocument.find params[:id]
    @doc.destroy
    redirect_to request.env["HTTP_REFERER"]
  end

end
