class ApplicationController < ActionController::Base
  before_filter :mailer_set_url_options

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  # TODO How to set default_url_options according to environment and current_store?
  # http://stackoverflow.com/questions/3432712/action-mailer-default-url-options-and-request-host
  # NOTE: Non-request based invocations, ie. rake tasks, resque workers will fail
  # when set according to request.host_with_port
  def mailer_set_url_options
    ActionMailer::Base.default_url_options = { host: Theartscene::Config.domain }
  end
end
