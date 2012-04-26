module EbayClient
  class Engine < ::Rails::Engine
    class_attribute :api

    CONFIG_FILE_PATH = %w(config ebay_client.yml)

    initializer 'ebay_client.load_configuration' do
      configurations = EbayClient::Configuration.load Rails.root.join *CONFIG_FILE_PATH
      configuration = configurations[Rails.env]

      EbayClient::Engine.api = EbayClient::Api.new configuration
    end
  end
end
