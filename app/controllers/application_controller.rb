class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :fetch_user

  private

  def fetch_user
    id = request.headers['AUTHENTICATED-USERID']
    user_role = request.headers['AUTHENTICATED-SCOPE']
    @user = User.where(id: id, user_role: user_role).first
    render json: { message: "Can't pass authorization with such ID and Scope" }, status: :unauthorized and return unless @user.present?
  end
end
