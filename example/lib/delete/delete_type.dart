import 'package:flutter/material.dart';

// expect_lint: delete_type
final Container a = Container(
  color: Colors.white,
);

final Widget b = Scaffold(
  // expect_lint: delete_type
  body: Container(
    color: Colors.white,
  ),
);
