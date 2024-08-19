import 'package:flutter/foundation.dart';

void a() {
  // expect_lint: delete_function
  print(
    "Hello World",
  );
  // expect_lint: delete_function
  debugPrintThrottled(
    "Hello World!",
  );
  // expect_lint: delete_function
  debugPrint(
    "Hello World!",
  );
}
