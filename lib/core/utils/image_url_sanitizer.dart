class ImageUrlSanitizer {
  static const fallbackImage = 'https://placehold.co/600x600/png?text=Product';

  static String firstValidUrl(Iterable<String> rawImages) {
    final urlRegex = RegExp(r'https?://[^\s"\[\]\\]+');

    for (final rawImage in rawImages) {
      final matches = urlRegex.allMatches(rawImage.trim());
      for (final match in matches) {
        final url = match.group(0)!.replaceAll(RegExp(r'[,.]+$'), '').trim();
        if (_isValidUrl(url)) return url;
      }
    }

    return fallbackImage;
  }

  static bool _isValidUrl(String url) {
    final uri = Uri.tryParse(url);
    return uri != null &&
        (uri.scheme == 'http' || uri.scheme == 'https') &&
        uri.host.isNotEmpty;
  }
}
