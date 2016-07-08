class ApplicationController < ActionController::Base
  include ControllerAuthorization

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  #before_filter :_basic_auth, if: -> { Rails.env.staging? }
  before_filter :set_paper_trail_whodunnit

  if Rails.configuration.force_ssl
    force_ssl
  end

  private

  def _basic_auth
    authenticate_or_request_with_http_basic do |user, password|
      user == Rails.application.secrets.basic_auth_user && \
      password == Rails.application.secrets.basic_auth_password
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?

  def append_info_to_payload(payload)
    super
    payload[:server_protocol] = request.env['SERVER_PROTOCOL']
    payload[:remote_ip] = request.remote_ip
    payload[:session_id] = request.env['rack.session.record'].try(:session_id)
    payload[:user_id] = current_user&.id
    payload[:pid] = Process.pid
    payload[:request_id] = request.uuid
    payload[:request_start] = request.headers['HTTP_X_REQUEST_START'].try(:gsub, /\At=/,'')
  end

  def info_for_paper_trail
    {
      user_id: current_user&.id,
      notification_code: params[:notification_id],
      session_id: request.env['rack.session.record']&.session_id,
      request_id: request.uuid
    }
  end

  def current_contact
    @current_contact || current_user.try(:contact)
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :name) }
  end
end
