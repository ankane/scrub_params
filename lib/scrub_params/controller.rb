module ScrubParams
  module Controller
    extend ActiveSupport::Concern

    included do
      before_filter :scrub_params
    end

    def scrub_params
      params.scrub!
    end

  end
end
