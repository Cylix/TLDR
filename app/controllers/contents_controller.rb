class ContentsController < DashboardController

  # GET /contents
  # list all contents
  def index
    @contents = current_user.contents
  end

end
