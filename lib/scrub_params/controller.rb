module ScrubParams
  module Controller
    extend ActiveSupport::Concern

    included do
      attr_accessor :unscrubbed_params
      before_filter :scrub_params
    end

    def scrub_params
      self.unscrubbed_params = params
      self.params = params.scrub
    end

  end
end
