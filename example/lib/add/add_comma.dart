//ignore_for_file: unused_field, edit_arrow_function, delete_function, edit_constructor_public_named_parameter
import 'package:bloc/bloc.dart';

class ExampleBloc extends Bloc<String, String> {
  final String _field;

  ExampleBloc(
    this._field,
    // expect_lint: add_comma
  ) : super("") {
    // expect_lint: add_comma
    on<String>((String event, Emitter<String> emit) {});
  }

  // expect_lint: add_comma
  arguments(String argument0) {
    // expect_lint: add_comma
    print("Hello");
  }

  // expect_lint: add_comma
  named({required String argument1}) {
    // expect_lint: add_comma
    print("Hello");
  }

  // expect_lint: add_comma
  optional([String? argument2]) {
    // expect_lint: add_comma
    print("Hello");
  }
}
