import 'package:actual/common/provider/go_router.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: _App(),
    ),
  );
}

class _App extends ConsumerWidget {
  const _App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      // return MaterialApp(
      theme: ThemeData(
        fontFamily: 'NotoSans',
      ),
      // home: HomeImsi(),
      debugShowCheckedModeBanner: false,
      // routerDelegate: router.routerDelegate,
      // routeInformationProvider: router.routeInformationProvider,
      // routeInformationParser: router.routeInformationParser,
      routerConfig: router,
    );
  }
}

class HomeImsi extends ConsumerWidget {
  const HomeImsi({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(secureStorageProvider);
    return ElevatedButton(
        onPressed: () async {
          await storage.deleteAll();
        },
        child: Text('delete Token'));
  }
}
