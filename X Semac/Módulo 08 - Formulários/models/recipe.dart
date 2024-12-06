class Recipe {
  String title;
  String ingredients;
  String preparation;
  String? category;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.preparation,
    required this.category,
    this.isFavorite = false,
  });
}
