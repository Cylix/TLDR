class ContentsController < DashboardController

  before_action :fetch_content, only: :update

  # GET /contents
  # GET /sources/:id/contents
  # list all contents (for the given source if specified)
  def index
    if params[:source_id]
      # Ensure source to have valid id and belongs to user (null otherwise)
      @source = current_user.sources.find_by_id(params[:source_id])
    elsif params[:category]
      # ensure category is valid (null otherwise)
      @category = (Content::CATEGORY_VALUES.map(&:to_s) & [params[:category]]).first
    end

    # If no source nor category, redirect to inbox
    redirect_to filter_contents_path(:inbox) and return if !@source && !@category

    @contents = current_user.contents
    @contents = @contents.where(source_id: @source.id) if @source
    @contents = @contents.where(category: @category) if @category
    @contents = @contents.where.not(category: :trashed) unless @category == 'trashed'

    partition = @contents.partition { |c| c.is_pinned? }
    @pinned   = partition.first
    @unpinned = partition.last
  end

  # PUT/PATCH /contents/:id
  # Update content
  def update
    if @content.update_attributes content_params
      render json: { success: true, content: @content }, status: 200
    else
      render json: { success: false, message: @content.errors.full_messages }, status: 400
    end
  rescue ArgumentError => e
    render json: { success: false, message: e.to_s }, status: 400
  end

  private


  # allowed params
  def content_params
    params.require(:content).permit(:is_pinned, :category)
  end

  # find the content for the id paramater
  # returns an error if no source has been found
  # returns an error if source belongs to another user
  def fetch_content
    @content = current_user.contents.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = I18n.t("controllers.contents.misc.unable_to_find")
    redirect_to root_path
  end

end
