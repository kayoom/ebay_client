module EbayClient
  class_attribute :api

  class Engine < ::Rails::Engine
    CONFIG_FILE_PATH = %w(config ebay_client.yml)

    initializer 'ebay_client.load_configuration' do
      configurations = EbayClient::Configuration.load Rails.root.join *CONFIG_FILE_PATH
      configuration = configurations[Rails.env]

      EbayClient.api = EbayClient::Api.new configuration
    end
  end
end
