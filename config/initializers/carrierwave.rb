CarrierWave.configure do |config|

  config.storage = :fog

  config.fog_credentials = {
     :provider                         => 'Google',
     :google_storage_access_key_id     => ENV['ASSET_KEY'],
     :google_storage_secret_access_key => ENV['ASSET_SECRET']
  }

  config.fog_directory = ENV['ASSET_BUCKET_NAME']

  # config.aws_bucket = ENV['S3_BUCKET_NAME']
  # config.aws_acl    = :public_read
  config.asset_host = "//#{ENV['ASSET_BUCKET_NAME']}.hungryhead.co"
  # config.aws_authenticated_url_expiration = 60 * 60 * 24 * 365

  config.cache_dir = "#{Rails.root}/tmp/uploads"
  config.validate_unique_filename = false
  config.validate_filename_format = false
  config.validate_remote_net_url_format = false

  # config.aws_credentials = {
  #   access_key_id:     ENV['S3_KEY'],
  #   secret_access_key: ENV['S3_SECRET']
  # }
end