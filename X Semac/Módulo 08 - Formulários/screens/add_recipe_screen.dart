import 'package:flutter/material.dart';
import '../models/recipe.dart';

// O usuário pode inserir o nome, ingredientes e modo de preparo de uma nova receita.

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
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;

  void _saveRecipe() {
    if (_titleController.text.isEmpty ||
        _ingredientsController.text.isEmpty ||
        _preparationController.text.isEmpty ||
        _selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Por favor, preencha todos os campos.')),
      );
      return;
    }

    final newRecipe = Recipe(
      title: _titleController.text,
      ingredients: _ingredientsController.text,
      preparation: _preparationController.text,
      category: _selectedCategory,
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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Nome da Receita'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o nome da receita.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ingredientsController,
                decoration: InputDecoration(labelText: 'Ingredientes'),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o campo Ingredientes.';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _preparationController,
                decoration: InputDecoration(labelText: 'Modo de Preparo'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, preencha o campo Modo de Preparo.';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Categoria'),
                value: _selectedCategory,
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                items: [
                  'Café da manhã',
                  'Almoço',
                  'Jantar',
                  'Sobremesa',
                  'Lanche'
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria.';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveRecipe();
                  }
                },
                child: Text('Salvar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white, // Cor do texto
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
