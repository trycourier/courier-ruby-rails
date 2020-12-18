# frozen_string_literal: true

require_relative "courier_rails/data_options"
require_relative "courier_rails/delivery_method"
require_relative "courier_rails/railtie"
require_relative "courier_rails/version"

module CourierRails
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key

    def initialize
      set_defaults
    end

    def set_defaults
      @api_key = if ENV.has_key?("COURIER_AUTH_TOKEN")
        ENV["COURIER_AUTH_TOKEN"]
      else
        ""
      end
    end
  end
end
