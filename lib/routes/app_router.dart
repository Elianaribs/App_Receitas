import 'package:app4_receitas/ui/base_screen.dart';
import 'package:app4_receitas/ui/fav_recipes/fav_recipes_view.dart';
import 'package:app4_receitas/ui/recipedetail/recipe_detail_view.dart';
import 'package:app4_receitas/ui/recipes/recipes_view.dart';
import 'package:go_router/go_router.dart';

import '../ui/Auth/auth_view.dart';

class AppRouter {
  late final GoRouter router;

  AppRouter() {
    router = GoRouter(
      initialLocation: '/login',
      routes: [
        GoRoute(path: '/login', builder: (context, state) => const AuthView()),
        ShellRoute(
          builder: (context, state, child) => BaseScreen(child: child),
          routes: [
            GoRoute(path: '/', builder: (context, state) => RecipesView()),
            GoRoute(
              path: '/recipe/:id',
              builder: (context, state) =>
                  RecipeDetailView(id: state.pathParameters['id']!),
            ),
            GoRoute(path: '/favorites', builder: (context, state) => FavRecipesView()),
          ],
        ),
      ],
    );
  }
}