class ApplicationController < ActionController::Base
  add_flash_types :info, :error, :warning

  # rescue_from ActionController::RoutingError,
  #             ActiveRecord::RecordNotFound do |ex|
  #   render_error(status: 404, action: :not_found)
  # end

private

  def render_error(status:, action:)
    respond_to do |format|
      format.html { render file: "#{Rails.root}/public/#{status}", layout: false, status: action }
      format.all  { render body: nil, status: status }
    end
  end

end
