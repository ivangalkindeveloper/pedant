//ignore_for_file: unused_field

import 'package:bloc/bloc.dart';

class Example1Bloc extends Bloc<String, String> {
  Example1Bloc()
      : super(
          "",
        );
}

class Example2Bloc extends Bloc<String, String> {
  Example2Bloc({
    // expect_lint: delete_bloc_cubit_dependent_bloc_cubit
    required Example1Bloc example1bloc2,
    // expect_lint: delete_bloc_cubit_dependent_bloc_cubit
  })  : this._example1bloc2 = example1bloc2,
        super(
          "",
        );

  // expect_lint: delete_bloc_cubit_dependent_bloc_cubit
  final Example1Bloc _example1bloc1 = Example1Bloc();
  // expect_lint: delete_bloc_cubit_dependent_bloc_cubit
  final Example1Bloc _example1bloc2;
}
