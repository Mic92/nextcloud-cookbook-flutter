import 'package:nextcloud_cookbook_flutter/src/models/category.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe.dart';
import 'package:nextcloud_cookbook_flutter/src/models/recipe_short.dart';
import 'package:nextcloud_cookbook_flutter/src/services/categories_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/category_recipes_short_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipe_provider.dart';
import 'package:nextcloud_cookbook_flutter/src/services/recipes_short_provider.dart';

class DataRepository {
  // Singleton
  static final DataRepository _dataRepository = DataRepository._internal();
  factory DataRepository() {
    return _dataRepository;
  }
  DataRepository._internal();

  // Provider List
  RecipesShortProvider recipesShortProvider = RecipesShortProvider();
  CategoryRecipesShortProvider categoryRecipesShortProvider =
      CategoryRecipesShortProvider();
  RecipeProvider recipeProvider = RecipeProvider();
  CategoriesProvider categoriesProvider = CategoriesProvider();

  // Actions
  Future<List<RecipeShort>> fetchRecipesShort({String category = 'all'}) {
    if (category == 'all') {
      return recipesShortProvider.fetchRecipesShort();
    } else {
      return categoryRecipesShortProvider.fetchCategoryRecipesShort(category);
    }
  }

  Future<Recipe> fetchRecipe(int id) {
    return recipeProvider.fetchRecipe(id);
  }

  Future<List<Category>> fetchCategories() {
    return categoriesProvider.fetchCategories();
  }

  Future<List<Category>> fetchCategoryImages(List<Category> categories) async {
    return await Future.wait(
      categories.map((category) => _fetchCategoryImage(category)).toList(),
    );
  }

  Future<Category> _fetchCategoryImage(Category category) async {
    List<RecipeShort> categoryRecipes = await categoryRecipesShortProvider
        .fetchCategoryRecipesShort(category.name);

    category.imageUrl = categoryRecipes.first.imageUrl;

    return category;
  }
}
