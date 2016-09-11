class EventBrochureUploader < ImageUploader

  process :resize_to_fill => [170, 224]

  version :slider do
    process :resize_to_fill => [69, 91]
  end

end
