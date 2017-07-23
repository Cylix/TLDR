class ContentsController < DashboardController

  before_action :fetch_content, only: :update

  # GET /contents
  # GET /sources/:id/contents
  # list all contents (for the given source if specified)
  def index
    if params[:source_id]
      # Ensure source to have valid id and belongs to user (null otherwise)
      @source = current_user.sources.find_by_id(params[:source_id])
    elsif params[:status]
      # Ensure status is valid (null otherwise)
      @status = (Content::STATUS_VALUES.map(&:to_s) & [params[:status]]).first
    elsif params[:category_id]
      # Ensure category is valid (null otherwise)
      @category = current_user.categories.find_by_id(params[:category_id])
    end

    # If no source nor status, redirect to inbox
    redirect_to filter_contents_path(:inbox) and return if !@source && !@status && !@category

    @contents = current_user.contents
    @contents = @contents.where(source_id: @source.id) if @source
    @contents = @contents.where(status: @status) if @status
    @contents = @contents.where(category_id: @category.id) if @category
    @contents = @contents.where.not(status: :trashed) unless @status == 'trashed'
  end

  # PUT/PATCH /contents/:id
  # Update content
  def update
    if @content.update_attributes content_params
      render json: { success: true, content: @content, category: @content.category }, status: 200
    else
      render json: { success: false, message: @content.errors.full_messages }, status: 400
    end
  rescue ArgumentError => e
    render json: { success: false, message: e.to_s }, status: 400
  end

  private

  # allowed params
  def content_params
    params.require(:content).permit(:category_id, :is_pinned, :status)
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
