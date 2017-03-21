class EbayClient::Configuration
  class ApiKey
    attr_accessor :appid, :devid, :certid, :token

    def initialize(key_values)
      key_values.each do |key, val|
        instance_variable_set "@#{key}", val
      end
    end
  end

  attr_accessor :version, :siteid, :routing, :url, :api_keys, :warning_level, :error_language, :current_key, :savon_log_level, :http_read_timeout

  def initialize(presets)
    presets.each do |key, val|
      instance_variable_set "@#{key}", val
    end

    @api_keys = @api_keys.map do |key_values|
      ApiKey.new key_values
    end.shuffle
    @current_key = @api_keys.first
  end

  def next_key!
    i = @api_keys.index(@current_key) + 1
    i = 0 if i >= @api_keys.count
    @current_key = @api_keys[i]
  end

  def appid
    @current_key.appid
  end

  def devid
    @current_key.devid
  end

  def certid
    @current_key.certid
  end

  def token
    @current_key.token
  end

  def token=(user_token)
    @current_key.token = user_token
  end

  def wsdl_file
    @wsdl_file ||= File.expand_path "../../../vendor/ebay/#{version}.wsdl", __FILE__
  end

  def preload?
    !!@preload
  end

  class << self
    def load(file)
      defaults = load_defaults
      configs = YAML.load(ERB.new(File.read(file)).result)

      configs.each_pair do |env, presets|
        env_defaults = defaults[env] || {}
        presets = presets || {}

        configs[env] = new env_defaults.merge(presets)
      end

      configs
    end

    protected
    def load_defaults
      YAML.load_file defaults_file
    end

    def defaults_file
      File.expand_path '../../../config/defaults.yml', __FILE__
    end
  end
end
