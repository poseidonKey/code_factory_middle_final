import 'package:actual/common/component/pagination_list_view.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/product/provider/product_provider.dart';
import 'package:actual/restaurant/view/restaurant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      itemBuilder: <ProductModel>(_, index, model) => GestureDetector(
        child: ProductCard.fromProductModel(model: model),
        onTap: () {
          context.goNamed(RestaurantDetailScreen.routeName,
              pathParameters: {'rid': model.restaurant.id});
          // Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => RestaurantDetailScreen(
          //       rid: model.restaurant.id,
          //     ),
          //   ),
          // );
        },
      ),
      provider: productProvider,
    );
  }
}
