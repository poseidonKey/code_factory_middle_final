import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/model/pagination_params.dart';
import 'package:actual/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaginationProviderNotifier<T extends IModelWithId,
        R extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final R repository;
  PaginationProviderNotifier({required this.repository})
      : super(
          CursorPaginationLoading(),
        ) {
    paginate();
  }

  Future<void> paginate({
    int fetchCount = 20,
    bool fetchMore = false,
    bool forceRefetch = false,
  }) async {
    try {
      if (state is CursorPagination && !forceRefetch) {
        final pState = state as CursorPagination;
        if (!pState.meta.hasMore) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      if (fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }
      PaginationParams paginationParams = PaginationParams(count: fetchCount);

      if (fetchMore) {
        final pState = state as CursorPagination<T>;
        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        paginationParams = paginationParams.copyWith(
          after: pState.data.last.id,
        );
      } else {
        if (state is CursorPagination && !forceRefetch) {
          final pState = state as CursorPagination<T>;
          state = CursorPaginationRefetching<T>(
              meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      final resp = await this.repository.paginate(
            paginationParams: paginationParams,
          );

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore<T>;
        state = resp.copyWith(
          data: [
            ...pState.data,
            ...resp.data,
          ],
        );
      } else {
        state = resp;
      }
    } catch (e, stack) {
      print(e);
      print(stack);
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다');
    }
  }
}
