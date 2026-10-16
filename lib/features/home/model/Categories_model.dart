class CategoriesModel {
  num? id;
  String? name;

  CategoriesModel({this.id, this.name});

  CategoriesModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }
}