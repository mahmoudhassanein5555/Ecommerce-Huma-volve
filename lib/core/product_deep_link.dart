String? productIdForDeepLink(String? routeName) {
  if (routeName == null) {
    return null;
  }

  final uri = Uri.tryParse(routeName);
  if (uri == null) {
    return null;
  }

  final segments = uri.pathSegments;
  String? productId;

  if (uri.scheme == 'ecommerce') {
    if (uri.host == 'product' && segments.length == 1) {
      productId = segments.single;
    }
  } else if (segments.length == 2 && segments.first == 'products') {
    productId = segments.last;
  } else if (segments.length == 1) {
    // Android may pass a custom-scheme link to Flutter as its path only.
    productId = segments.single;
  }

  return productId;
}
