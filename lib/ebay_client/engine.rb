module EbayClient
  mattr_accessor :api

  class Engine < ::Rails::Engine
    CONFIG_FILE_PATH = %w(config ebay_client.yml)

    initializer 'ebay_client.load_configuration' do
      configurations = EbayClient::Configuration.load Rails.root.join *CONFIG_FILE_PATH
      configuration = configurations[Rails.env]

      EbayClient.api = EbayClient::Api.new configuration

      ::Savon.configure do |config|
        config.logger = Rails.logger
        config.log_level = :error
      end
    end
  end
end
