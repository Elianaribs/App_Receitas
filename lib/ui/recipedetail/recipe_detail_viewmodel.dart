import 'dart:async';
import 'package:app4_receitas/data/repositories/recipe_repository.dart';
import 'package:get/get.dart';
import '../../data/models/recipe.dart';
import '../../di/service_locator.dart';

class RecipeDetailViewModel extends GetxController{
  final _repository = getIt<RecipeRepository>();

  //Estados
  final Rxn<Recipe> _recipe = Rxn<Recipe>();
  final RxBool _isLoading = false.obs;
  final RxString _errorMessage = ''.obs;
  final RxBool _isFavorite = false.obs;

  // Getters
  Recipe? get recipes => _recipe.value;
  bool get isLoading => _isLoading.value;
  String? get errorMessage => _errorMessage.value;
  bool get isFavorite => _isFavorite.value;

  Future<void> loadRecipe(String id) async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';
      _recipe.value = await _repository.getRecipeById(id);
    }catch (e) {
      _errorMessage.value = 'Falha ao buscar receita ${e.toString()}';
    } finally{
      _isLoading.value = false;
    }

    }
    Future<bool> isRecipeFavorite(String recipeId, String userId) async {
      try {
        _isLoading.value = true;
        _errorMessage.value = '';
        final favRecipes = await _repository.getFavRecipes(userId);
        return favRecipes.any((recipe) => recipe.id == recipeId);
      } catch (e) {
        _errorMessage.value =
        'Falha ao buscar receita favorita ${e.toString()}';
      } finally {
        _isLoading.value = false;
      }
      return false;
    }

    Future<void>toggleFavorite() async{

    }

  }