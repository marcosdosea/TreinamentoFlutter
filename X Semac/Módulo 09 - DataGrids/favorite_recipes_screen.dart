import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'recipe_detail_screen.dart';

class FavoriteRecipesScreen extends StatelessWidget {
  final List<Recipe> recipes;

  FavoriteRecipesScreen({required this.recipes});

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes =
        recipes.where((recipe) => recipe.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Receitas Favoritas'),
      ),
      body: favoriteRecipes.isEmpty
          ? Center(
              child: Text(
                'Nenhuma receita favorita encontrada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: favoriteRecipes.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Dois itens por linha
                crossAxisSpacing: 8.0, // Espaçamento horizontal
                mainAxisSpacing: 8.0, // Espaçamento vertical
                childAspectRatio: 1.2, // Ajuste proporção largura/altura
              ),
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: recipe),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          recipe.category ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
