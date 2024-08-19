// ignore_for_file: unused_field, unused_element

class A {
  final String field;

  const A(
    // expect_lint: edit_constructor_public_named_parameter
    this.field,
  );
}

class ExampleClass extends A {
  final String field0;
  final String? field1;
  final String? _field2;
  final String? field3 = "";

  const ExampleClass.meh(
    // expect_lint: edit_constructor_public_named_parameter
    super.field,
    // expect_lint: edit_constructor_public_named_parameter
    this.field0,
    // expect_lint: edit_constructor_public_named_parameter
    this.field1,
    // expect_lint: edit_constructor_public_named_parameter
    this._field2,
  );
}

class _ExampleClass extends A {
  final String field0;
  final String? field1;
  final String? _field2;
  final String? field3 = "";

  const _ExampleClass.meh(
    // expect_lint: edit_constructor_private_named_parameter
    super.field,
    // expect_lint: edit_constructor_private_named_parameter
    this.field0,
    // expect_lint: edit_constructor_private_named_parameter
    this.field1,
    // expect_lint: edit_constructor_private_named_parameter
    this._field2,
  );
}
