class CategoriesController < ApplicationController

  # POST /categories
  # create a new category
  def create
    @category = current_user.categories.new category_params

    if @category.save
      render json: { success: true, category: @category }, status: 200
    else
      render json: { success: false, message: @category.errors.full_messages }, status: 400
    end
  end

  private

  # allowed params
  def category_params
    params.require(:category).permit(:name)
  end

end
