module ScrubParams
  module Parameters
    extend ActiveSupport::Concern

    included do
      attr_accessor :scrubbed_keys
    end

    def scrub
      self.scrubbed_keys = []
      hash = {}
      each_pair do |k, v|
        hash[k] = scrub_value(k, v)
      end
      if scrubbed_keys.any?
        ActiveSupport::Notifications.instrument("scrubbed_parameters.action_controller", keys: scrubbed_keys.uniq)
      end
      hash
    end

    protected

    def scrub_value(key, value)
      case value
      when String
        scrubbed_value = ActionController::Base.helpers.strip_tags(value)
        if scrubbed_value != value
          self.scrubbed_keys << key
        end
        scrubbed_value
      when Hash
        hash = {}
        value.each do |k, v|
          hash[k] = scrub_value(k, v)
        end
        hash
      when Array
        value.map{|v| scrub_value(key, v) }
      else
        value
      end
    end

  end
end
