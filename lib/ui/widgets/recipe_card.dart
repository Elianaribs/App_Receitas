import 'package:app4_receitas/data/models/recipe.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Container(
        padding: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                recipe.image!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null
                    ? child
                    : Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                errorBuilder: (context, child, stackTrace) => Container(
                  height: 200,
                  width: double.infinity,
                  color: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.error),
                ),
              ),
            ),
            ListTile(
              titleTextStyle: GoogleFonts.dancingScript(
                fontWeight: FontWeight.bold,
                fontSize: 28,
                color: Colors.black87,
              ),
              title: Text(recipe.name, textAlign: TextAlign.center),
              subtitleTextStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Theme.of(context).colorScheme.primary,
              ),
              subtitle: Text('${recipe.cuisine}', textAlign: TextAlign.center),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.help_outline_sharp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${recipe.difficulty}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.watch_later_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${recipe.prepTimeMinutes} min',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.people_alt_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${recipe.servings}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.local_fire_department_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${recipe.caloriesPerServing} cal',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Icon(
                      Icons.star_border_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    Text(
                      '${recipe.rating?.toStringAsFixed(1) ?? 'N/A'} (${recipe.reviewCount ?? 0})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}