CarrierWave.configure do |config|
  if Rails.env.test? || Rails.env.cucumber?
    config.storage = :file
    config.enable_processing = false
    config.root = "#{Rails.root}/tmp"
  else
    config.storage = :aws
  end
  config.aws_bucket = ENV['S3_BUCKET_NAME']
  config.aws_acl    = :public_read
  config.asset_host = 'http://d2on167u5w9qv7.cloudfront.net'
  config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365
  config.cache_dir = "#{Rails.root}/tmp/uploads"

  config.validate_unique_filename = false
  config.validate_filename_format = false
  config.validate_remote_net_url_format = false      

  config.aws_credentials = {
    access_key_id:     ENV['S3_KEY'],
    secret_access_key: ENV['S3_SECRET']
  }
end