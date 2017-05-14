class ContentsController < DashboardController

  # GET /contents
  # GET /sources/:id/contents
  # list all contents (for the given source if specified)
  def index
    if params[:source_id]
      # Ensure source to have valid id and belongs to user (null otherwise)
      @source = current_user.sources.find_by_id(params[:source_id])
    elsif params[:type]
      # ensure type is valid (null otherwise)
      @type = (["snoozed", "done", "trash"] & [params[:type]]).first
    end

    @contents = current_user.contents
    @contents = @contents.where(source_id: @source.id) if @source

    partition = @contents.partition { |c| c.pinned? }
    @pinned   = partition.first
    @unpinned = partition.last
  end

end
