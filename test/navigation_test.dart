import 'package:dinka_english_dictionary/core/router/app_router.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('router includes expected routes', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final router = container.read(appRouterProvider);
    final paths = router.configuration.routes
        .whereType<GoRoute>()
        .map((r) => r.path)
        .toList(growable: false);
    expect(paths, contains('/'));
    expect(paths, contains('/details/:id'));
    expect(paths, contains('/about'));
  });
}
