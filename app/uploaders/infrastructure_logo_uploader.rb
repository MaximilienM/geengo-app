class InfrastructureLogoUploader < ImageUploader

  # Override store dir here as Infrastructure has sti on it
  # Always use infrastructure in the path and not the sti class
  def store_dir
    "uploads/infrastructure/#{mounted_as}/#{model.id}"
  end

  def default_url
    "/images/fallback/infrastructure/#{mounted_as}/" + [version_name, "default.png"].compact.join('_')
  end

  version :index do
    process :resize_to_fill => [34, 34]
  end

  version :show do
    process :resize_to_fill => [60, 60]
  end

end
