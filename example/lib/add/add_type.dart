//ignore_for_file: unused_local_variable

final List<int> acctNumbers = ""
    .codeUnits
    .map(
      (
        // expect_lint: add_type
        unit,
      ) =>
          unit -
          '0'.codeUnitAt(
            0,
          ),
    )
    .toList();

// expect_lint: add_type
const globalVariable = "";

void doSome({
  // expect_lint: add_type
  field1,
  // expect_lint: add_type
  field2,
}) {
  // expect_lint: add_type
  const functionVariable0 = "";
  // expect_lint: add_type
  const functionVariable1 = "";
}

class ExampleClass {
  const ExampleClass({
    // expect_lint: add_type
    classField,
  }) : this.classField = classField;

  // expect_lint: add_type
  final classField;
}
