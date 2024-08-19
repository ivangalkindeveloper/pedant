import 'package:flutter/widgets.dart';

class ExampleClassBase {
  const ExampleClassBase();

  final String field = "One";

  void doSomething() {}
}

class ExampleClass extends ExampleClassBase {
  const ExampleClass();

  // expect_lint: add_override
  final String field = "Two";

  // expect_lint: add_override
  void doSomething() {}
}

class Controller extends ChangeNotifier {
  Controller();

  // expect_lint: add_override
  void notifyListeners() {}
}
