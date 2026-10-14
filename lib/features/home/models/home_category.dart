class HomeCategory {
  final int id;
  final String name;

  const HomeCategory({required this.id, required this.name});

  factory HomeCategory.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if (id is! num || name is! String) {
      throw const FormatException('Invalid category response from store.');
    }

    return HomeCategory(id: id.toInt(), name: name);
  }
}
