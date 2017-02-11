class SourcesController < ApplicationController

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
    @source = current_user.sources.new sources_params

    if @source.save
      flash[:success] = I18n.t("controllers.sources.create.success")
      redirect_to action: :index
    else
      flash[:resource_errors] = @source.errors.full_messages
      render 'new'
    end
  end

  # GET /sources/{id}
  # form to edit an existing content source
  def edit
  end

  # PUT/PATCH /sources/{id}
  # update an existing content source
  def update
    if @source.update_attributes sources_params
      flash[:success] = I18n.t("controllers.sources.update.success")
      redirect_to action: :index
    else
      flash[:resource_errors] = @source.errors.full_messages
      render 'edit'
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
    params.require(:source).permit(:name, :description, :url, :rss_feed)
  end

  # find the content source for the id paramater
  # returns an error if no source has been found
  # returns an error if source belongs to another user
  def fetch_source
    @source = current_user.sources.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    flash[:error] = I18n.t("controllers.sources.misc.unable_to_find")
    redirect_to '/'
  end

end
