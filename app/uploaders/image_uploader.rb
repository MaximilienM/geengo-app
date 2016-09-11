class ImageUploader < GeengoUploader
  
  include CarrierWave::MiniMagick
  
  def default_url
    "/images/fallback/#{model.class.to_s.underscore}/" + [version_name, "default.png"].compact.join('_')
  end
  
  def extension_white_list
    %w(jpg jpeg gif png)
  end
  
end