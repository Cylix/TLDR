class StaticPagesController < ApplicationController

  # GET /
  # Root path
  def home
    redirect_to contents_path if user_signed_in?
  end

end
