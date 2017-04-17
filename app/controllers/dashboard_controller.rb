class DashboardController < ApplicationController

  # authentication
  before_action :authenticate_user!

  # layout
  layout 'dashboard'

end
