import 'package:flutter/widgets.dart';

// expect_lint: add_controller_postfix
class SomeControll extends ChangeNotifier {
  SomeControll();
}

class ExtendsControll extends SomeControll {
  ExtendsControll();
}
