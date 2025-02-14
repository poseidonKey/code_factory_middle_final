import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/rating/model/rating_model.dart';
import 'package:actual/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingStateNotifier, CursorPaginationBase, String>((ref, rid) {
  final repository = ref.watch(
    restaurantRatingRepositoryProvider(rid),
  );
  return RestaurantRatingStateNotifier(repository: repository);
});

class RestaurantRatingStateNotifier extends PaginationProviderNotifier<
    RatingModel, RestaurantRatingRepository> {
  RestaurantRatingStateNotifier({
    required super.repository,
  });
}
