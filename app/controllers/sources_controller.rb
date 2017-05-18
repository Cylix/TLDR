class SourcesController < DashboardController

  before_action :authenticate_user!
  before_action :fetch_source, only: [:edit, :update, :destroy]

  # GET /sources
  # list all content sources
  def index
    @sources = current_user.sources
  end

  # GET /sources/new
  # form to create a new content source
  def new
    @source = Source.new
  end

  # POST /sources
  # create a new content source
  def create
    @source = Source.new sources_params.merge user: current_user

    if @source.save
      flash[:success] = I18n.t("controllers.sources.create.success")
      redirect_to action: :index
    else
      flash.now[:resource_errors] = @source.errors.full_messages
      render 'new', status: 400
    end
  rescue ActiveRecord::SubclassNotFound
    @source = Source.new sources_params.merge type: nil
    flash.now[:error] = I18n.t("controllers.sources.create.unrecognized_source_type")
    render 'new' and return
  end

  # GET /sources/{id}
  # form to edit an existing content source
  def edit
  end

  # PUT/PATCH /sources/{id}
  # update an existing content source
  def update
    @source.attributes = sources_params

    # if type has changed to another valid type
    # make source become the new valid source
    # this is important to run the appropriate validations
    @source = @source.becomes @source.type.constantize if @source.type_changed? && @source.has_allowed_type?

    if @source.save
      flash[:success] = I18n.t("controllers.sources.update.success")
      redirect_to action: :index
    else
      flash.now[:resource_errors] = @source.errors.full_messages
      render 'edit', status: 400
    end
  end

  # DELETE /sources/{id}
  # destroy an existing content source
  def destroy
    @source.destroy
    flash[:success] = I18n.t("controllers.sources.destroy.success")
    redirect_to action: :index
  end

  private

  # allowed params
  def sources_params
    params.require(:source).permit(:name, :description, :type, :url, :rss_feed)
  end

  # find the content source for the id paramater
  # returns an error if no source has been found
  # returns an error if source belongs to another user
  def fetch_source
    @source = current_user.sources.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = I18n.t("controllers.sources.misc.unable_to_find")
    redirect_to root_path
  end

end
