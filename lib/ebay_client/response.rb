class EbayClient::Response
  class Error
    attr_reader :classification, :code, :parameters, :long_message, :short_message, :severity_code

    def initialize values
      @classification = values[:error_classification]
      @code = values[:error_code]
      @parameters = get_parameters values[:error_parameters] || []
      @long_message = values[:long_message]
      @short_message = values[:short_message]
      @severity_code = values[:severity_code]
    end

    protected
    def get_parameters values
      values = [values] if values.is_a? Hash

      {}.tap do |hash|
        values.each do |vals|
          key = vals[:attributes!][:param_id] rescue next
          val = vals[:value] or next

          hash[key] = val
        end
      end
    end
  end

  attr_reader :timestamp, :ack, :build, :version, :errors, :payload, :correlation_id

  def initialize values
    @timestamp = values.delete :timestamp
    @ack = values.delete :ack
    @build = values.delete :build
    @version = values.delete :version
    @errors = get_errors values.delete(:errors) || []
    @correlation_id = values.delete :correlation_id
    @payload = values
  end

  def success?
    ack == 'Success'
  end

  def failure?
    ack == 'Failure'
  end

  def warning?
    ack == 'Warning'
  end

  def payload!
    !failure? && payload || raise_failure
  end

  protected
  def raise_failure
    raise errors.map(&:short_message).join(', ')
  end

  def get_errors values
    values = [values] if values.is_a? Hash

    values.map do |vals|
      Error.new vals
    end
  end
end
