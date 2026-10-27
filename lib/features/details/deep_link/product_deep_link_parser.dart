/// Custom URL scheme this app registers (see ios/Runner/Info.plist and
/// android/app/src/main/AndroidManifest.xml). Fully functional today,
/// without any external setup: `humavolve://products/42`.
const String kProductLinkScheme = 'humavolve';

/// Illustrative only - see the Final Report / README note on this feature.
/// Parsing already recognizes this shape so that once a real domain is
/// owned, hosted with the required `apple-app-site-association` /
/// `assetlinks.json` files, and wired into the platform projects, Universal
/// Links / App Links work without any Dart-side changes. No such domain is
/// configured by this change, and this scheme is not claimed to resolve.
const String kIllustrativeHttpsHost = 'your-domain.example';

/// Parses an incoming [uri] into a product id, or returns null if it isn't
/// a recognized, valid product deep link. Recognizes two URI shapes:
///  - `humavolve://products/{id}` (custom scheme: authority is "products",
///    the id is the single path segment - how custom-scheme deep links are
///    conventionally structured in Flutter).
///  - `https://<any-host>/products/{id}` (path-based - the shape Universal
///    Links / App Links would use once/if a real domain is configured).
/// The id must be a positive integer; anything else (missing, non-numeric,
/// zero/negative, extra path segments, wrong scheme) returns null so the
/// caller can safely ignore malformed or unrelated links.
int? parseProductDeepLinkId(Uri uri) {
  if (uri.scheme == kProductLinkScheme) {
    if (uri.host != 'products') return null;
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length != 1) return null;
    return _parsePositiveId(segments.first);
  }

  if (uri.scheme == 'https' || uri.scheme == 'http') {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();
    if (segments.length != 2 || segments.first != 'products') return null;
    return _parsePositiveId(segments[1]);
  }

  return null;
}

int? _parsePositiveId(String raw) {
  final id = int.tryParse(raw);
  if (id == null || id <= 0) return null;
  return id;
}
