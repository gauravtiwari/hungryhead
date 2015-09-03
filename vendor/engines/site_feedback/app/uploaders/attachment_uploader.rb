# encoding: utf-8

class AttachmentUploader < CarrierWave::Uploader::Base

  include CarrierWave::MiniMagick
  #include ::CarrierWave::Backgrounder::Delay

  process :set_content_type
  storage :fog


  def process_uri(uri)
    return URI.parse(uri)
  end

  def store_dir
    "uploads/site_feedbacks/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png pdf doc)
  end

end
