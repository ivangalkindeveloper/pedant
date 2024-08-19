//ignore_for_file: unused_local_variable

const String topLevel = "TopLevel";

class ExampleClass {
  ExampleClass();

  final String field = "One";

  // expect_lint: add_this
  late final String anotherField = field;

  void doSome({
    required String value,
  }) {}

  void doSomething() {
    // expect_lint: add_this
    String a = field;
    String b = a.toLowerCase();
    // expect_lint: add_this
    anotherField.replaceAll(
      "",
      "",
    );
    // expect_lint: add_this
    field.split(
      "",
    );
    // expect_lint: add_this
    doSome(
      value: this.field,
    );
  }

  bool check() => topLevel == "One" ? true : false;
}
