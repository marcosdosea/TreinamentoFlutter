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
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Receitas'),
      ),
      body: _recipes.isEmpty
          ? Center(child: Text('Nenhuma receita adicionada.'))
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_recipes[index].title),
                  trailing: IconButton(
                    icon: Icon(
                      _recipes[index].isFavorite
                          ? Icons.favorite // Ícone de coração cheio
                          : Icons.favorite_border, // Ícone de coração vazio
                      color: Colors.red,
                    ),
                    onPressed: () {
                      setState(() {
                        _recipes[index].isFavorite =
                            !_recipes[index].isFavorite;
                      });
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RecipeDetailScreen(recipe: _recipes[index]),
                      ),
                    );
                  },
                );
              },
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
}
