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
  final _formKey = GlobalKey<FormState>();
  String? _selectedCategory;
  DateTime? _selectedDate;

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
        date: _selectedDate);

    widget.onAddRecipe(newRecipe);
    Navigator.pop(context);
  }

  // Função para abrir o DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked; // Atualiza a data selecionada
      });
    }
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
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Data de Registro',
                    style: TextStyle(fontSize: 18),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _selectedDate == null
                            ? 'Selecionar'
                            : _selectedDate!
                                .toLocal()
                                .toString()
                                .split(' ')[0], // Formato da data
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
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
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
