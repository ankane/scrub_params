module ScrubParams
  module Parameters
    extend ActiveSupport::Concern

    included do
      attr_accessor :scrubbed_keys
    end

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
        # gsub specific cases
        # safer than CGI.unescapeHTML
        scrubbed_value = ActionController::Base.helpers.strip_tags(value)
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
