require "scrub_params/version"
require "action_controller"
require "sanitize"
require "scrub_params/log_subscriber"

module ActionController
  class Parameters < ActiveSupport::HashWithIndifferentAccess
    attr_accessor :scrubbed_keys

    def scrub!
      self.scrubbed_keys = []
      each_pair do |k, v|
        self[k] = scrub_value(k, v)
      end
      if scrubbed_keys.any?
        ActiveSupport::Notifications.instrument("scrubbed_parameters.action_controller", keys: scrubbed_keys)
      end
      self
    end

    protected

    def scrub_value(key, value)
      case value
      when Hash
        h = {}
        value.each do |k, v|
          h[k] = scrub_value(k, v)
        end
        h
      when Array
        value.map{|v| scrub_value(key, v) }
      when String
        scrubbed_value = Sanitize.clean(value)
        if scrubbed_value != value
          self.scrubbed_keys << key unless scrubbed_keys.include?(key)
        end
        scrubbed_value
      else
        value
      end
    end

  end
end

module ActionController
  class Base
    protected

    before_filter :scrub_params

    def scrub_params
      params.scrub!
    end
  end
end
