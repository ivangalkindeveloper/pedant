import 'package:bloc/bloc.dart';

// expect_lint: add_bloc_postfix
class SomeBlos extends Bloc<String, String> {
  SomeBlos()
      : super(
          "",
        ) {
    on<String>(
      (
        String event,
        Emitter<String> emit,
      ) {},
    );
    on<String>(
      (
        String event,
        Emitter<String> emit,
      ) {},
    );
  }
}
