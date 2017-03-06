class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def process_uri(uri)
    URI.parse(uri)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :cover do
    process resize_to_fit: [900, nil]
  end

  version :large do
    process resize_to_fit: [1600, nil]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
