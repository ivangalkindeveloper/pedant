import 'package:flutter/material.dart';

void a() {
  // expect_lint: delete_print
  print("Hello World");
  // expect_lint: delete_print
  debugPrint("Hello World!");
}
