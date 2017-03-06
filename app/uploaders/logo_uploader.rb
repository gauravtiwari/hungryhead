class LogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  storage :fog

  def process_uri(uri)
    URI.parse(uri)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini do
    process resize_to_fill: [40, 33]
  end

  version :avatar do
    process resize_to_fill: [110, 110]
  end

  version :thumb do
    process resize_to_fill: [307, 153]
  end

  version :large_thumb do
    process resize_to_fill: [353, 313]
  end

  version :square do
    process resize_to_fill: [600, 600]
  end

  version :sidebar do
    process resize_to_fill: [185, 123]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
