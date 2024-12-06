import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'add_recipe_screen.dart';
import 'recipe_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Recipe> _recipes = [];

  void _addRecipe(Recipe recipe) {
    setState(() {
      _recipes.add(recipe);
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteRecipes =
        _recipes.where((recipe) => recipe.isFavorite).toList();
    final otherRecipes =
        _recipes.where((recipe) => !recipe.isFavorite).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
      ),
      body: _recipes.isEmpty
          ? Center(
              //heightFactor: 2,
              child: Text(
                'Nenhuma receita adicionada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              // Column usado para empilhar as listas de receitas verticalmente
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (favoriteRecipes.isNotEmpty)
                  Container(
                    // Container usado para estilizar a seção de receitas favoritas
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      // Outra Column para organizar o título e a lista de favoritas
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Receitas Favoritas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          // Column para empilhar cada receita favorita
                          children: favoriteRecipes
                              .map((recipe) => _buildRecipeTile(recipe))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                if (otherRecipes.isNotEmpty)
                  Container(
                    // Container para estilizar a seção de outras receitas
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      // Outra Column para organizar o título e a lista de outras receitas
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Outras Receitas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Column(
                          // Column para empilhar cada receita não favorita
                          children: otherRecipes
                              .map((recipe) => _buildRecipeTile(recipe))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddRecipeScreen(onAddRecipe: _addRecipe),
            ),
          );
        },
        child: Text(
          '+',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
    );
  }

  Widget _buildRecipeTile(Recipe recipe) {
    return Row(
      // Row usado para alinhar o título da receita e o ícone de favorito horizontalmente
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          recipe.title,
          style: TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: Icon(
            recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
          ),
          onPressed: () {
            setState(() {
              recipe.isFavorite = !recipe.isFavorite;
            });
          },
        ),
      ],
    );
  }
}
