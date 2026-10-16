class HomeProductEntity {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;

  const HomeProductEntity({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';
}