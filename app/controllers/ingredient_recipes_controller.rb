class IngredientRecipesController < RecipesController
  prepend_before_action :set_ingredient

private
  def set_recipes
    @recipes = @ingredient.recipes.includes(:ingredients)
    @message = "No Recipes Found" if @recipes.empty?
  end

  def set_recipe
    @recipe = @ingredient.recipes.find_by(id: params[:id])
    @message = "Cannot Find Recipe With ID #{params[:id]}" if @recipe.nil?
  end

  def set_ingredient
    @ingredient = Ingredient.find_by(name: params[:ingredient_id])
    if @ingredient.nil?
      @message = "Cannot Find Ingredient Name '#{params[:ingredient_id]}'"
      render 'errors/not_found'
    end
  end

  def set_parent_path
    @parent_resource = "/ingredients"
    @parent_path     = "/ingredients/#{params[:ingredient_id]}"
  end
end
