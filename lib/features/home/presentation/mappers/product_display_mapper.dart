import '../../../../core/dummy_data.dart' show Product;
import '../../../../core/theme.dart';
import '../../domain/entities/product_entity.dart';

/// escuelajs has no color/size variant data, so this is the single safe
/// default the existing Product Details screen's selectors fall back to.
const List<String> kDefaultProductSizes = ['One Size'];

const String kFallbackProductImageUrl =
    'https://via.placeholder.com/300x300.png?text=No+Image';

/// Shared by [HomeCubit] and [ProductDetailsCubit] so both map the API's
/// [ProductEntity] onto the existing UI [Product] model the same way.
extension ProductDisplayMapper on ProductEntity {
  Product toDisplayProduct() => Product(
    id: id.toString(),
    name: title,
    description: description,
    price: price,
    imageUrl: images.isNotEmpty ? images.first : kFallbackProductImageUrl,
    colors: const [AppTheme.primary],
    sizes: kDefaultProductSizes,
  );
}
