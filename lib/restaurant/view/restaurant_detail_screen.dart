import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:actual/product/component/product_card.dart';
import 'package:actual/product/model/product_model.dart';
import 'package:actual/rating/component/rating_card.dart';
import 'package:actual/rating/model/rating_model.dart';
import 'package:actual/restaurant/component/restaurant_card.dart';
import 'package:actual/restaurant/model/restaurant_detail_model.dart';
import 'package:actual/restaurant/model/restaurant_model.dart';
import 'package:actual/restaurant/provider/restaurant_provider.dart';
import 'package:actual/restaurant/provider/restaurant_rating_provider.dart';
import 'package:actual/user/provider/basket_provider.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletons/skeletons.dart';

class RestaurantDetailScreen extends ConsumerStatefulWidget {
  final String rid;
  const RestaurantDetailScreen({super.key, required this.rid});

  static String get routeName => 'restaurantDetail';

  @override
  ConsumerState<RestaurantDetailScreen> createState() =>
      _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState
    extends ConsumerState<RestaurantDetailScreen> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    ref.read(restaurantProvider.notifier).getDetail(id: widget.rid);
    controller.addListener(scrollListener);
  }

  void scrollListener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(restaurantRatingProvider(widget.rid).notifier),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final state = ref.watch(restaurantDetailProvider(widget.rid));
    final ratingsState = ref.watch(
      restaurantRatingProvider(widget.rid),
    );
    final basket = ref.watch(basketProvider);

    if (state == null) {
      return DefaultLayout(
          child: Center(
        child: CircularProgressIndicator(),
      ));
    }
    return DefaultLayout(
      title: state.name,
      child: CustomScrollView(
        controller: controller,
        slivers: [
          renderTop(model: state),
          if (state is! RestaurantDetailModel) renderLoading(),
          if (state is RestaurantDetailModel) renderLabel(),
          if (state is RestaurantDetailModel)
            renderProducts(
              products: state.products,
              restaurant: state,
            ),
          if (ratingsState is CursorPagination<RatingModel>)
            renderRatings(models: ratingsState.data),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // context.pushNamed(BasketScreen.routeName);
          context.pushNamed('basket');
        },
        child: badges.Badge(
          showBadge: basket.isNotEmpty,
          badgeContent: Text(basket
              .fold<int>(
                0,
                (previous, next) => previous + next.count,
              )
              .toString()),
          child: Icon(Icons.shopping_basket_outlined),
          badgeStyle: badges.BadgeStyle(
            badgeColor: Colors.white,
          ),
        ),
        backgroundColor: PRIMARY_COLOR,
      ),
    );
  }

  SliverPadding renderRatings({
    required List<RatingModel> models,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: RatingCard.fromModel(model: models[index]),
          ),
          childCount: models.length,
        ),
      ),
    );
  }

  SliverPadding renderLoading() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          List.generate(
            3,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: 32),
              child: SkeletonParagraph(
                style: SkeletonParagraphStyle(
                  lines: 5,
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantModel model}) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          RestaurantCard.fromModel(
            model: model,
            isDetail: true,
          )
        ],
      ),
    );
  }

  SliverPadding renderLabel() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  SliverPadding renderProducts({
    required List<RestaurantProductModel> products,
    required RestaurantModel restaurant,
  }) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          ((context, index) {
            final model = products[index];
            return InkWell(
              onTap: () {
                ref.read(basketProvider.notifier).addToBasket(
                      product: ProductModel(
                        id: model.id,
                        name: model.name,
                        detail: model.detail,
                        imgUrl: model.imgUrl,
                        price: model.price,
                        restaurant: restaurant,
                      ),
                    );
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: ProductCard.fromRestaurantProductModel(model: model),
              ),
            );
          }),
          childCount: products.length,
        ),
      ),
    );
  }
}
