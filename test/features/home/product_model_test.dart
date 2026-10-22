import 'package:ecommerce_app_huma_volve/features/home/data/models/product_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductModel.fromJson', () {
    test('parses the escuelajs product schema', () {
      final model = ProductModel.fromJson({
        'id': 35,
        'title': 'Futuristic Holographic Soccer Cleats',
        'price': 39,
        'description': 'desc',
        'category': {'id': 4, 'name': 'Shoes'},
        'images': [
          'https://i.imgur.com/qNOjJje.jpeg',
          'https://i.imgur.com/NjfCFnu.jpeg',
        ],
      });

      expect(model.id, 35);
      expect(model.title, 'Futuristic Holographic Soccer Cleats');
      expect(model.price, 39.0);
      expect(model.images, [
        'https://i.imgur.com/qNOjJje.jpeg',
        'https://i.imgur.com/NjfCFnu.jpeg',
      ]);
      expect(model.category.id, 4);
      expect(model.category.name, 'Shoes');
    });

    test('filters out malformed (non-http) image entries', () {
      final model = ProductModel.fromJson({
        'id': 1,
        'title': 'x',
        'price': 1,
        'description': '',
        'category': {'id': 1, 'name': 'x'},
        'images': ['not-a-url', '["nested"]', 'https://ok.com/a.jpg'],
      });

      expect(model.images, ['https://ok.com/a.jpg']);
    });

    test('falls back to safe defaults for missing/null fields', () {
      final model = ProductModel.fromJson({'id': 1});

      expect(model.title, 'Untitled product');
      expect(model.description, '');
      expect(model.price, 0.0);
      expect(model.images, isEmpty);
      expect(model.category.name, 'Uncategorized');
    });

    test('toEntity carries fields through unchanged', () {
      final model = ProductModel.fromJson({
        'id': 2,
        'title': 'T',
        'price': 5,
        'description': 'd',
        'category': {'id': 3, 'name': 'C'},
        'images': ['https://x.com/a.jpg'],
      });

      final entity = model.toEntity();

      expect(entity.id, 2);
      expect(entity.title, 'T');
      expect(entity.price, 5.0);
      expect(entity.category.id, 3);
      expect(entity.category.name, 'C');
    });
  });
}
