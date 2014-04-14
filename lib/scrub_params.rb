require "scrub_params/version"
require "active_support/hash_with_indifferent_access"
require "action_controller"
require "scrub_params/parameters"
require "scrub_params/controller"
require "scrub_params/log_subscriber"

if defined?(ActionController::Parameters)
  ActionController::Parameters.send :include, ScrubParams::Parameters
else
  ActiveSupport::HashWithIndifferentAccess.send :include, ScrubParams::Parameters
end

ActionController::Base.send :include, ScrubParams::Controller
