class ContentsController < DashboardController

  # GET /contents
  # GET /sources/:id/contents
  # list all contents (for the given source if specified)
  def index
    @source = current_user.sources.find_by_id(params[:source_id]) if params[:source_id]

    @contents = current_user.contents
    @contents = @contents.where(source_id: @source.id) if @source
  end

end
