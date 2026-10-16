
import 'package:ecommerce_app_huma_volve/features/home/domain/entity/home_category_entity.dart';
class HomeProductsEntity {
   int id;
   String title;
   String slug;
   int price;
   String description;
   HomeCategoryEntity category;
   List<String> images;

  HomeProductsEntity(
      { this.id=0,
        this.title="",
        this.slug="",
        this.price=0,
        this.description="",
        this.category=const HomeCategoryEntity(),
        this.images=const[],

      }
      );

}
