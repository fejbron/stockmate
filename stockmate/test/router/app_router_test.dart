import 'package:flutter_test/flutter_test.dart';
import 'package:stockmate/src/router/app_router.dart';

void main() {
  test('createAppRouter returns a fresh router instance', () {
    final first = createAppRouter();
    final second = createAppRouter();

    expect(identical(first, second), false);

    first.dispose();
    second.dispose();
  });
}
