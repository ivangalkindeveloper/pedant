import 'package:bloc/bloc.dart';

class SomeBloc extends Bloc<String, String> {
  SomeBloc()
      : super(
          "",
        ) {
    on<String>(
      (
        String event,
        Emitter<String> emit,
      ) {},
    );
  }
}

void sort({
  required List<String> strings,
}) =>
    strings.sort();
