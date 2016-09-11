class PhotoUploader < ImageUploader

  process :resize_to_fit => [500, 500]

  version :main do
    process :resize_to_fit => [190, 190]
  end

  version :topbar do
    process :resize_to_fit => [30, 30]
  end

  version :convers do
    process :resize_to_fit => [37, 37]
  end

end