import 'package:actual/common/model/cursor_pagination_model.dart';
import 'package:actual/common/model/model_with_id.dart';
import 'package:actual/common/provider/pagination_provider.dart';
import 'package:actual/common/utils/pagination_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

typedef PaginationWidgetBuilder<T extends IModelWithId> = Widget Function(
  BuildContext context,
  int index,
  T model,
);

class PaginationListView<T extends IModelWithId>
    extends ConsumerStatefulWidget {
  final StateNotifierProvider<PaginationProviderNotifier, CursorPaginationBase>
      provider;
  final PaginationWidgetBuilder<T> itemBuilder;
  const PaginationListView({
    required this.itemBuilder,
    required this.provider,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PaginationListViewState<T>();
}

class _PaginationListViewState<T extends IModelWithId>
    extends ConsumerState<PaginationListView> {
  final ScrollController controller = ScrollController();
  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  @override
  void dispose() {
    controller.removeListener(listener);
    controller.dispose();
    super.dispose();
  }

  void listener() {
    PaginationUtils.paginate(
      controller: controller,
      provider: ref.read(widget.provider.notifier),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    if (state is CursorPaginationLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is CursorPaginationError) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(state.message),
          SizedBox(
            height: 16,
          ),
          ElevatedButton(
              onPressed: () {
                ref.read(widget.provider.notifier).paginate(
                      forceRefetch: true,
                    );
              },
              child: Text('다시 시도'))
        ],
      );
    }

    final cp = state as CursorPagination<T>;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        controller: controller,
        itemCount: cp.data.length + 1,
        itemBuilder: (_, index) {
          if (index == cp.data.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Center(
                child: cp is CursorPaginationFetchingMore
                    ? CircularProgressIndicator()
                    : Text('last Data'),
              ),
            );
          }
          final pItem = cp.data[index];
          return widget.itemBuilder(
            context,
            index,
            pItem,
          );
        },
        separatorBuilder: (_, index) {
          return SizedBox(height: 16.0);
        },
      ),
    );
  }
}
