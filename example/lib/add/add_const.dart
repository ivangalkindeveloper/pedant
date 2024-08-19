//ignore_for_file: unused_local_variable, unused_element

class ConstClass {
  const ConstClass({
    required this.age,
  });

  final int? age;
}

// // ---

// expect_lint: add_const
final int globalVar = 0;

// expect_lint: add_const
final int anotherVar = 0;

final ConstClass topLevelConst = ConstClass(
  age: globalVar,
);

void b({
  required int age,
}) async {
  // expect_lint: add_const
  final int localVar = 0;
  final List<String> errorsList = [];

  void func() {}

  ConstClass(
    age: age,
  );

  // expect_lint: add_const
  final int a = 0;
  // expect_lint: add_const
  final ConstClass constVariable = ConstClass(
    age: 20,
  );
}

Future<int> _getString() => Future.value(
      0,
    );

const List<ConstClass> a = [
  ConstClass(
    age: 12,
  ),
];
