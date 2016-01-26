class EbayClient::Response
  class Exception < ::StandardError
    attr_accessor :code
    attr_accessor :error

    #def to_s
    #  error.to_s
    #end
    #alias_method :inspect, :to_s
    #alias_method :message, :to_s
  end

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

    def to_s
      <<-END
        #{short_message} - #{code}

        #{long_message}
      END
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

    class << self
      attr_accessor :errors

      def for_code code
        self.errors ||= Hash.new do |h, k|
          h[k] = ::EbayClient::Response::Exception.new.tap do |exception|
            exception.code = k
          end
        end

        errors[code.to_s]
      end
    end
  end

  attr_reader :timestamp, :ack, :build, :version, :errors, :payload, :correlation_id

  def initialize values
    @ack = values.delete :ack
    @build = values.delete :build
    @version = values.delete :version
    @errors = get_errors values.delete(:errors) || []
    @correlation_id = values.delete :correlation_id
    values.delete :'@xmlns'
    @timestamp = values[:timestamp]
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
  def exception
    @exception ||= errors.first && EbayClient::Response::Error.for_code(errors.first.code).tap { |e| e.error = errors.first }
  end

  def raise_failure
    raise exception
  end

  def get_errors values
    values = [values] if values.is_a? Hash

    values.map do |vals|
      Error.new(vals)
    end
  end
end
