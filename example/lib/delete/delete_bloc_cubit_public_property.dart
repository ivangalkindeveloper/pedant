//ignore_for_file: edit_constructor_public_named_parameter, unused_field

import 'package:bloc/bloc.dart';

class ExampleBloc extends Bloc<String, String> {
  ExampleBloc(
    // expect_lint: delete_bloc_cubit_public_property
    this.property1, {
    required String property2,
    // expect_lint: delete_bloc_cubit_public_property
    required this.property3,
  })  : this._property2 = property2,
        super(
          "",
        ) {}

  // expect_lint: delete_bloc_cubit_public_property
  final String property1;
  final String _property2;
  // expect_lint: delete_bloc_cubit_public_property
  final String property3;
}

class ExampleCubit extends Cubit<String> {
  ExampleCubit(
    // expect_lint: delete_bloc_cubit_public_property
    this.property1, {
    required String property2,
    // expect_lint: delete_bloc_cubit_public_property
    required this.property3,
  })  : this._property2 = property2,
        super(
          "",
        ) {}

  // expect_lint: delete_bloc_cubit_public_property
  final String property1;
  final String _property2;
  // expect_lint: delete_bloc_cubit_public_property
  final String property3;
}
