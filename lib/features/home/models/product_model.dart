class ProductModel {
  final int id;
  final String title;
  final double price;
  final String description;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.images,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      description: json['description'] ?? '',
      images: json['images'] is List
          ? List<String>.from(json['images'].map((e) => e.toString()))
          : [],
    );
  }
}