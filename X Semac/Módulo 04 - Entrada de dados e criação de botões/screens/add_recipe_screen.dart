import 'package:flutter/material.dart';
import '../models/recipe.dart';

class AddRecipeScreen extends StatefulWidget {
  final Function(Recipe) onAddRecipe;

  AddRecipeScreen({required this.onAddRecipe});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _titleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _preparationController = TextEditingController();

  void _saveRecipe() {
    if (_titleController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _preparationController.text.isEmpty) {
      return;
    }

    final newRecipe = Recipe(
      title: _titleController.text,
      ingredients: _ingredientsController.text,
      preparation: _preparationController.text,
    );

    widget.onAddRecipe(newRecipe);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Receita'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Nome da Receita'),
            ),
            TextField(
              controller: _ingredientsController,
              decoration: InputDecoration(labelText: 'Ingredientes'),
              maxLines: 3,
            ),
            TextField(
              controller: _preparationController,
              decoration: InputDecoration(labelText: 'Modo de Preparo'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRecipe,
              child: Text('Salvar'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white, // Cor do texto
              ),
            ),
          ],
        ),
      ),
    );
  }
}
