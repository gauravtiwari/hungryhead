# config/initializers/compression.rb

Rails.application.configure do
  # Use environment names or environment variables:
  # break unless Rails.env.production?
  break unless ENV['ENABLE_COMPRESSION'] == '1'

  uglifier = Uglifier.new output: { comments: :copyright }
  config.assets.compile = true
  config.assets.debug = false

  config.assets.js_compressor = uglifier
  config.assets.css_compressor = :sass

  config.middleware.use Rack::Deflater

  config.middleware.use HtmlCompressor::Rack,
    compress_javascript: true,
    enabled: true,
    javascript_compressor: uglifier,
    remove_comments: true,
    remove_form_attributes: false,
    remove_http_protocol: false,
    remove_https_protocol: false,
    remove_input_attributes: true,
    remove_intertag_spaces: false,
    remove_javascript_protocol: true,
    remove_link_attributes: false,
    remove_multi_spaces: true,
    remove_quotes: true,
    remove_script_attributes: false,
    remove_style_attributes: false,
    simple_boolean_attributes: true,
    simple_doctype: false
end