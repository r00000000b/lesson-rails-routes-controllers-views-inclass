class RecipesController < ApplicationController
  before_action :set_errors
  before_action :set_parent_path
  before_action :set_courses_category, only: [:new, :edit]
  before_action :set_recipe, only: [:show, :edit, :update, :destroy]
  before_action :set_recipes, only: [:index]

  def index
    render 'recipes/index'
  end

  def show
    render 'recipes/show'
  end

  def new
    @recipe = flash[:recipe].nil? ? Recipe.new :  Recipe.new(flash[:recipe])
    render 'recipes/new'
  end

  def create
    @recipe = Recipe.new(recipe_params)

    if @recipe.save
      recipe_ingredients_params[:ingredients].each do |ingredient_name|
        ingredient = Ingredient.find_or_create_by(name: ingredient_name)
        @recipe.recipe_ingredient_lists.create(ingredient_id: ingredient.id)
      end
      redirect_to "#{@parent_path}#{recipe_path(@recipe)}"
    else
      flash[:recipe] = @recipe
      flash[:errors] = @recipe.errors.messages
      redirect_to "#{@parent_path}#{new_recipe_path}"
    end
  end

  def edit
    @recipe = flash[:recipe].nil? ? @recipe : Recipe.new(flash[:recipe])
    render 'recipes/edit'
  end

  def update
    @recipe.assign_attributes(recipe_params)

    if @recipe.save
      redirect_to "#{@parent_path}#{recipe_path(@recipe)}"
    else
      flash[:recipe] = @recipe
      flash[:errors] = @recipe.errors.messages
      redirect_to "#{@parent_path}#{edit_recipe_path}"
    end
  end

  def destroy
    if !@recipe.nil?
      @recipe.destroy
    end
    redirect_to "#{@parent_path}#{recipes_path}"
  end

private
  def set_recipes
    @recipes = Recipe.includes(:ingredients).all
    @message = "No Recipes Found" if @recipes.empty?
  end

  def set_recipe
    @recipe  = Recipe.find_by(id: params[:id])
    @message = "Cannot Find Recipe With ID #{params[:id]}" if @recipe.nil?
  end

  def set_errors
    @errors  = flash[:errors]
  end

  def set_courses_category
    @courses_categories = Course.order(:name).pluck(:name, :id)
  end

  def set_parent_path
    @parent_resource = "/"
    @parent_path     = ""
  end

  def recipe_params
    params.require(:recipe).permit(:name, :instructions, :servings, :course_id)
  end

  def recipe_ingredients_params
    params.require(:recipe).permit(ingredients: [])
  end
end
