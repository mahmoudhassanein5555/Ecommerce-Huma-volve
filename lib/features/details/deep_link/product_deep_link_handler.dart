import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../screens/product_details_loader_screen.dart';
import 'product_deep_link_parser.dart';

/// Signals when it's safe to push a deep-link route onto the app's
/// Navigator - i.e. once the existing splash screen has navigated away.
///
/// This exists because a cold-launch link can arrive through either
/// [ProductDeepLinkHandler.listen]'s stream or [ProductDeepLinkHandler.
/// handleInitialLink] depending on the platform, and either can fire before
/// splash's own delayed `pushReplacement`. Pushing a route on top of splash
/// in that window would make splash's `pushReplacement` swap out *that*
/// route instead of splash's own, yanking the user back to Login. [ready]
/// lets the handler simply wait out that window instead of guessing which
/// delivery path will win the race.
class DeepLinkReadiness {
  DeepLinkReadiness._();

  static final Completer<void> _completer = Completer<void>();

  static Future<void> get ready => _completer.future;

  /// Call once, right when splash navigates away (see `SplashScreen`).
  static void markReady() {
    if (!_completer.isCompleted) _completer.complete();
  }
}

/// Routes incoming product deep links to [ProductDetailsLoaderScreen] on
/// top of whatever the app is currently showing, using plain [Navigator]
/// (the project's only routing mechanism - no second routing system).
///
/// Two delivery paths are both listened to, since which one carries a
/// cold-start link varies by platform:
///  - [listen]: the ongoing stream, for links arriving while the process is
///    already alive, and (on some platforms) redelivering the link that
///    just launched the app.
///  - [handleInitialLink]: explicitly asks for the link that cold-launched
///    the app, if any. Both paths route through [_handle], which dedupes
///    and waits on [DeepLinkReadiness] before navigating, so it doesn't
///    matter which one fires first or whether both fire.
class ProductDeepLinkHandler {
  factory ProductDeepLinkHandler() => _instance;

  ProductDeepLinkHandler._internal({AppLinks? appLinks})
    : _appLinks = appLinks ?? AppLinks();

  static final ProductDeepLinkHandler _instance =
      ProductDeepLinkHandler._internal();

  final AppLinks _appLinks;
  Uri? _lastHandledUri;

  StreamSubscription<Uri> listen(GlobalKey<NavigatorState> navigatorKey) {
    return _appLinks.uriLinkStream.listen(
      (uri) => _handle(uri, () => navigatorKey.currentState),
      onError: (_) {},
    );
  }

  Future<void> handleInitialLink(NavigatorState? navigatorState) async {
    final uri = await _appLinks.getInitialLink();
    if (uri == null) return;
    await _handle(uri, () => navigatorState);
  }

  Future<void> _handle(
    Uri uri,
    NavigatorState? Function() getNavigatorState,
  ) async {
    // Ignore a repeat of the same link (some platforms redeliver the
    // cold-start link via both paths) so we never push a duplicate Product
    // Details screen for one incoming link. Checked/set before awaiting
    // readiness so a near-simultaneous second delivery is caught too.
    if (_lastHandledUri == uri) return;

    final productId = parseProductDeepLinkId(uri);
    if (productId == null) return;

    _lastHandledUri = uri;
    await DeepLinkReadiness.ready;

    getNavigatorState()?.push(
      MaterialPageRoute(
        builder: (_) => ProductDetailsLoaderScreen(productId: productId),
      ),
    );
  }
}
