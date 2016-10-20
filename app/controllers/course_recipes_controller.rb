class CourseRecipesController < RecipesController
  prepend_before_action :set_course

private
  def set_recipes
    @recipes = @course.recipes.includes(:ingredients)
    @message = "No Recipes Found" if @recipes.empty?
  end

  def set_recipe
    @recipe = @course.recipes.find_by(id: params[:id])
    @message = "Cannot Find Recipe With ID #{params[:id]}" if @recipe.nil?
  end

  def set_course
    @course = Course.find_by(name: params[:course_id])
    if @course.nil?
      @message = "Cannot Find Course Name '#{params[:course_id]}'"
      render 'errors/not_found'
    end
  end

  def set_parent_path
    @parent_resource = "/courses"
    @parent_path     = "/courses/#{params[:course_id]}"
  end
end
