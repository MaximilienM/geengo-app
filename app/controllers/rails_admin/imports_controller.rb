# encoding : utf-8

class RailsAdmin::ImportsController < RailsAdmin::MainController

  def create

    import_class = params[:model_name].classify.constantize
    import_attributes_key = params[:model_name].singularize

    @object = import_class.new(params[import_attributes_key])

    # Temporarily disable geocoding for the imported_class if this class is geocoded
    @object.imported_class.geocoder_options[:geocode] = false if @object.imported_class.geocoder_options

    if @object.save
      Resque.enqueue(ImagesImporter, @object.imported_class.to_s)
      Resque.enqueue(GeocodeNotGeocoded, @object.imported_class.to_s)
      build_flash
      redirect_to list_path(:model_name => params[:model_name])
    else
      handle_save_error
    end

    # re-enable geocoding for the imported_class
    @object.imported_class.geocoder_options[:geocode] = true if @object.imported_class.geocoder_options

  rescue ActiveRecord::StatementInvalid
    @object.errors.add(:file, "n'est pas valide")
    handle_save_error
  end

  protected

  def build_notice(count_attribute, key, singular, plural = singular)
    count = @object.send(count_attribute)
    pluralize(count, I18n.t("#{key}.one") + " #{singular}", I18n.t("#{key}.other") + " #{plural}") if count > 0
  end

  def build_flash
    key = "activerecord.models.#{params[:model_name].gsub('s_imports', '')}"

    created_notice = build_notice(:created_count, key, "crée", "crées")
    updated_notice = build_notice(:updated_count, key, "mis à jour")
    flash[:notice] = [created_notice, updated_notice].compact.join('. ')

    flash[:error] = if @object.discards.present?
      key = "activerecord.models.import_discard"
      flash[:error] = pluralize(@object.discards.count, I18n.t("#{key}.one"), I18n.t("#{key}.other"))
    end
  end

end