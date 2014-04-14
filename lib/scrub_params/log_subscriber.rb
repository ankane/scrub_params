module ScrubParams
  class LogSubscriber < ActiveSupport::LogSubscriber
    def scrubbed_parameters(event)
      scrubbed_keys = event.payload[:keys]
      debug("Scrubbed parameters: #{scrubbed_keys.join(", ")}")
    end

    def logger
      ActionController::Base.logger
    end
  end
end

ScrubParams::LogSubscriber.attach_to :action_controller
