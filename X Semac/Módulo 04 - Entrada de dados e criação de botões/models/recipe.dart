class Recipe {
  String title;
  String ingredients;
  String preparation;
  bool isFavorite;

  Recipe({
    required this.title,
    required this.ingredients,
    required this.preparation,
    this.isFavorite = false,
  });
}
