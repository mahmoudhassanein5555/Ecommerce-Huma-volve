class CategoryModel {
  final num? id;
  final String? name;

  CategoryModel({this.id, this.name});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(id: json['id'], name: json['name']);
  }

  CategoryModel copyWith({num? id, String? name}) {
    return CategoryModel(id: id ?? this.id, name: name ?? this.name);
  }
}
