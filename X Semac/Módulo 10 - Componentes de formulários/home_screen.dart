import 'package:flutter/material.dart';
import '../models/recipe.dart';
import 'add_recipe_screen.dart';
import 'favorite_recipes_screen.dart';
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text('Receitas Favoritas'),
              onTap: () {
                Navigator.pop(context); // Fecha o menu lateral
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        FavoriteRecipesScreen(recipes: _recipes),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: _recipes.isEmpty
          ? Center(
              child: Text(
                'Nenhuma receita adicionada.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: _recipes.length,
              itemBuilder: (context, index) {
                final recipe = _recipes[index];
                return Dismissible(
                  key: ValueKey(recipe.title + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    color: Colors.red,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _recipes.removeAt(index);
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Receita "${recipe.title}" removida!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: recipe.isFavorite
                          ? Colors.blue[50]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                              height: 4.0), // Espaço entre título e categoria
                          Text(
                            recipe.category!, // Exibe a categoria da receita
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  Colors.grey[600], // Estilo para a categoria
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          recipe.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          setState(() {
                            recipe.isFavorite = !recipe.isFavorite;
                          });
                        },
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                RecipeDetailScreen(recipe: recipe),
                          ),
                        );
                      },
                    ),
                  ),
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
