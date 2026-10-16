
class ProductModel {
  final int id;
  final String title;
  final num price;
  final List<String> images;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      price: json['price'],
      images: (json['images'] as List<dynamic>)
          .map((image) => image.toString())
          .toList(),
    );
  }
}
