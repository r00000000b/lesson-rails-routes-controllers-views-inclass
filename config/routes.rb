Rails.application.routes.draw do
  resources :ingredients, only: [:index] do
    resources :recipes, controller: 'ingredient_recipes'
  end

  resources :courses, only: [:index] do
    resources :recipes, controller: 'course_recipes'
  end

  resources :recipes
end
