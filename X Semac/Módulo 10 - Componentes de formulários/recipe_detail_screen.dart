import 'package:flutter/material.dart';
import '../models/recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  RecipeDetailScreen({required this.recipe});

  @override
  Widget build(BuildContext context) {
    String formattedDate = recipe.date != null
        ? "${recipe.date!.day.toString().padLeft(2, '0')}/"
            "${recipe.date!.month.toString().padLeft(2, '0')}/"
            "${recipe.date!.year}"
        : 'Data não informada';

    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data de Registro: $formattedDate',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              'Ingredientes',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(recipe.ingredients),
            SizedBox(height: 16),
            Text(
              'Modo de Preparo',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(recipe.preparation),
          ],
        ),
      ),
    );
  }
}
