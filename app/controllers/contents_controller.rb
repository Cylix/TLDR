class ContentsController < ApplicationController

  before_action :authenticate_user!

  # GET /contents
  # list all contents
  def index
    @contents = current_user.contents
  end

end
