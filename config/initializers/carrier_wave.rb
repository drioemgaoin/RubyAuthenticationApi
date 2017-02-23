class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    true
  end
end

if Rails.env.test?

  CarrierWave.root = Rails.root.join('test/fixtures/files')

  CarrierWave.configure do |config|
    config.storage = NullStorage
    config.enable_processing = false
  end

else

  CarrierWave.configure do |config|
    config.fog_provider = 'fog/dropbox'
    config.fog_credentials = {
      provider:                        'dropbox',
      dropbox_oauth2_access_token:     ENV['CLOUD_STORAGE_ACCESS_KEY']
    }
    config.fog_directory  = 'RubyLoginComponent'
    config.fog_attributes = { 'Cache-Control' => "max-age=#{365.day.to_i}" }
  end

end
