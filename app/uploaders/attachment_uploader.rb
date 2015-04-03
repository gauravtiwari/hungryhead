# encoding: utf-8

class AttachmentUploader < Mailboxer::AttachmentUploader

  include ::CarrierWave::Backgrounder::Delay
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

  def extension_white_list
    %w(pdf doc docx xls xlsx)
  end

end
