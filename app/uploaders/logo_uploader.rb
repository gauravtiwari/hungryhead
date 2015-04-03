# encoding: utf-8

class LogoUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  #include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MimeTypes
  include CarrierWave::MimetypeFu
  process :set_content_type

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :aws


  def process_uri(uri)
    return URI.parse(uri)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :mini do
    process :resize_to_fill => [40, 33]
  end

  version :avatar do
    process :resize_to_fill => [110, 110]
  end

  version :thumb do 
    process :resize_to_fill => [307, 153]
  end

  version :large_thumb do 
    process :resize_to_fill => [353, 313]
  end

  version :square do
    process :resize_to_fill => [600, 600]
  end

  version :sidebar do
    process :resize_to_fill => [185, 123]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
