// expect_lint: edit_multiple_variable
const String a = "", b = "", c = "";

class ExampleClass {
  const ExampleClass({
    required this.f,
    required this.g,
    required this.h,
  });

  // expect_lint: edit_multiple_variable
  final String f, g, h;
}
