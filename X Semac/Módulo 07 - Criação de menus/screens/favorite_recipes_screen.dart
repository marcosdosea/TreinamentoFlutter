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
          : ListView.builder(
              itemCount: favoriteRecipes.length,
              itemBuilder: (context, index) {
                final recipe = favoriteRecipes[index];
                return Container(
                  margin: EdgeInsets.all(8.0),
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.blue[50], // Azul para receitas favoritas
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    title: Text(
                      recipe.title,
                      style: TextStyle(fontSize: 16),
                    ),
                    trailing: Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    onTap: () {
                      // Navegar para a tela de detalhes da receita
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailScreen(recipe: recipe),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
