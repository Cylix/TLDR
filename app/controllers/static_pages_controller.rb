class StaticPagesController < ApplicationController

  # GET /
  # Root path
  def home
    redirect_to filter_contents_path(:inbox) if user_signed_in?
  end

end
