class ProductsModel {
  ProductsModel({
    num? id,
    String? title,
    String? slug,
    num? price,
    String? description,
    Category? category,
    List<String>? images,
    String? creationAt,
    String? updatedAt,
  }) {
    _id = id;
    _title = title;
    _slug = slug;
    _price = price;
    _description = description;
    _category = category;
    _images = images;
    _creationAt = creationAt;
    _updatedAt = updatedAt;
  }

  ProductsModel.fromJson(dynamic json) {
    _id = json['id'];
    _title = json['title'];
    _slug = json['slug'];
    _price = json['price'];
    _description = json['description'];
    _category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    _images = json['images'] != null ? json['images'].cast<String>() : [];
    _creationAt = json['creationAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _title;
  String? _slug;
  num? _price;
  String? _description;
  Category? _category;
  List<String>? _images;
  String? _creationAt;
  String? _updatedAt;
  ProductsModel copyWith({
    num? id,
    String? title,
    String? slug,
    num? price,
    String? description,
    Category? category,
    List<String>? images,
    String? creationAt,
    String? updatedAt,
  }) => ProductsModel(
    id: id ?? _id,
    title: title ?? _title,
    slug: slug ?? _slug,
    price: price ?? _price,
    description: description ?? _description,
    category: category ?? _category,
    images: images ?? _images,
    creationAt: creationAt ?? _creationAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  num? get id => _id;
  String? get title => _title;
  String? get slug => _slug;
  num? get price => _price;
  String? get description => _description;
  Category? get category => _category;
  List<String>? get images => _images;
  String? get creationAt => _creationAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['title'] = _title;
    map['slug'] = _slug;
    map['price'] = _price;
    map['description'] = _description;
    if (_category != null) {
      map['category'] = _category?.toJson();
    }
    map['images'] = _images;
    map['creationAt'] = _creationAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}

class Category {
  Category({
    num? id,
    String? name,
    String? slug,
    String? image,
    String? creationAt,
    String? updatedAt,
  }) {
    _id = id;
    _name = name;
    _slug = slug;
    _image = image;
    _creationAt = creationAt;
    _updatedAt = updatedAt;
  }

  Category.fromJson(dynamic json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _image = json['image'];
    _creationAt = json['creationAt'];
    _updatedAt = json['updatedAt'];
  }
  num? _id;
  String? _name;
  String? _slug;
  String? _image;
  String? _creationAt;
  String? _updatedAt;
  Category copyWith({
    num? id,
    String? name,
    String? slug,
    String? image,
    String? creationAt,
    String? updatedAt,
  }) => Category(
    id: id ?? _id,
    name: name ?? _name,
    slug: slug ?? _slug,
    image: image ?? _image,
    creationAt: creationAt ?? _creationAt,
    updatedAt: updatedAt ?? _updatedAt,
  );
  num? get id => _id;
  String? get name => _name;
  String? get slug => _slug;
  String? get image => _image;
  String? get creationAt => _creationAt;
  String? get updatedAt => _updatedAt;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['name'] = _name;
    map['slug'] = _slug;
    map['image'] = _image;
    map['creationAt'] = _creationAt;
    map['updatedAt'] = _updatedAt;
    return map;
  }
}
