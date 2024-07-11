class Shop {
  final String id;
  String title;
  String imageUrl;
  bool isFavorite;

  Shop({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.isFavorite = false,
  });
}
