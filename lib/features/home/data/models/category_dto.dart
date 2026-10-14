import '../../domain/entities/category.dart';

class CategoryDto {
  const CategoryDto({required this.id, required this.name});

  final String id;
  final String name;

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    final name = json['name'];
    if ((id is! int && id is! String) ||
        name is! String ||
        name.trim().isEmpty) {
      throw const FormatException('The category response is incomplete.');
    }
    return CategoryDto(id: id.toString(), name: name.trim());
  }

  Category toEntity() => Category(id: id, name: name);
}
