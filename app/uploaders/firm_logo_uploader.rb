class FirmLogoUploader < ImageUploader
  
  process :resize_to_fit => [92, 30]
  
end
