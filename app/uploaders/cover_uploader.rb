# encoding: utf-8

class CoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick
  #include ::CarrierWave::Backgrounder::Delay
  include CarrierWave::MimeTypes
  include CarrierWave::MimetypeFu
  process :set_content_type

  storage :aws

  def process_uri(uri)
    return URI.parse(uri)
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  version :cover do
    process :resize_to_fit => [900, nil]
  end

  version :large do
    process :resize_to_fit => [1400, nil]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end
