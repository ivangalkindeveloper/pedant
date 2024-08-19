// ignore_for_file: edit_multiple_variable

class ExampleClass {
  // expect_lint: add_const_constructor
  ExampleClass({
    required this.a,
  }) : this.b = "";

  final String a;
  final String b;
}

class TextExample {
  // expect_lint: add_const_constructor
  TextExample();

  String someString() => "";
}

final ExampleClass example = ExampleClass(
  a: _someString(),
);
final String b = _someString();

String _someString() => "";

class ExampleTwoClass {
  // expect_lint: add_const_constructor
  ExampleTwoClass({
    required this.f,
    required this.g,
    required this.h,
  });

  final String f, g, h;
}
