import 'package:dartz/dartz.dart';
import 'package:ecommerce_app_huma_volve/core/failure/failure.dart';
import 'package:ecommerce_app_huma_volve/features/home/domain/repository/home_repository.dart';
import '../entity/home_product_entity.dart';

class GetProductsUseCase {
  final HomeRepository homeRepository;

  GetProductsUseCase(this.homeRepository);

  static const String _fallbackImage =
      'https://placehold.co/600x600/png?text=Product';

  Future<Either<Failure, List<HomeProductEntity>>> invoke(
      int? categoryId, {
        required int limit,
        required int offset,
      }) async {
    final result = await homeRepository.getProducts(
      categoryId,
      limit: limit,
      offset: offset,
    );

    return result.fold(
          (failure) => Left(failure),
          (products) {
        for (final product in products) {
          final validImages = _extractValidImageUrls(product.images);
          product.images = validImages.isNotEmpty
              ? validImages
              : [_fallbackImage];
        }

        return Right(products);
      },
    );
  }

  List<String> _extractValidImageUrls(List<String> rawImages) {
    final List<String> validUrls = [];
    final urlRegex = RegExp(r'https?://[^\s"\[\]\\]+');

    for (final raw in rawImages) {
      final str = raw.trim();
      if (str.isEmpty) continue;

      final matches = urlRegex.allMatches(str);

      for (final match in matches) {
        String url = match.group(0)!;
        url = url.replaceAll(RegExp(r'[,.]+$'), '').trim();

        if (_isValidImageUrl(url)) {
          validUrls.add(url);
        }
      }
    }

    return validUrls;
  }

  bool _isValidImageUrl(String url) {
    if (url.isEmpty) return false;

    final uri = Uri.tryParse(url);

    if (uri == null) return false;

    if (!uri.hasScheme || (uri.scheme != 'http' && uri.scheme != 'https')) {
      return false;
    }

    return uri.host.isNotEmpty;
  }
}