class ApplicationController < ActionController::Base
  include Symphonia::ControllerExtensions
  helper Symphonia::ApplicationHelper
end
