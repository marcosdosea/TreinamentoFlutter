class Recipe {
  String title;
  String ingredients;
  String preparation;
  String? category;
  bool isFavorite;
  final DateTime? date;

  Recipe(
      {required this.title,
      required this.ingredients,
      required this.preparation,
      required this.category,
      this.isFavorite = false,
      this.date});
}
