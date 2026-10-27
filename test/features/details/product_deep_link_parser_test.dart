import 'package:ecommerce_app_huma_volve/features/details/deep_link/product_deep_link_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseProductDeepLinkId (custom scheme)', () {
    test('parses a valid humavolve product link', () {
      expect(parseProductDeepLinkId(Uri.parse('humavolve://products/42')), 42);
    });

    test('rejects a non-numeric id', () {
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://products/abc')),
        isNull,
      );
    });

    test('rejects a zero or negative id', () {
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://products/0')),
        isNull,
      );
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://products/-5')),
        isNull,
      );
    });

    test('rejects a missing id', () {
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://products/')),
        isNull,
      );
      expect(parseProductDeepLinkId(Uri.parse('humavolve://products')), isNull);
    });

    test('rejects the wrong path segment', () {
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://categories/42')),
        isNull,
      );
    });

    test('rejects extra path segments', () {
      expect(
        parseProductDeepLinkId(Uri.parse('humavolve://products/42/reviews')),
        isNull,
      );
    });
  });

  group('parseProductDeepLinkId (https, illustrative)', () {
    test('parses a valid https product link regardless of host', () {
      expect(
        parseProductDeepLinkId(Uri.parse('https://example.com/products/7')),
        7,
      );
    });

    test('rejects a path that is not /products/{id}', () {
      expect(
        parseProductDeepLinkId(Uri.parse('https://example.com/items/7')),
        isNull,
      );
      expect(
        parseProductDeepLinkId(Uri.parse('https://example.com/products')),
        isNull,
      );
    });
  });

  group('parseProductDeepLinkId (unrecognized input)', () {
    test('rejects an unrelated scheme', () {
      expect(
        parseProductDeepLinkId(Uri.parse('mailto:test@example.com')),
        isNull,
      );
    });

    test('rejects a completely malformed/empty uri', () {
      expect(parseProductDeepLinkId(Uri()), isNull);
    });
  });
}
