import 'package:bloc/bloc.dart';

// expect_lint: add_bloc_cubit_state_sealed
class SomeBloc extends Bloc<String, ExampleState> {
  SomeBloc()
      : super(
          const $ExampleState(),
        ) {}
}

// expect_lint: add_bloc_cubit_state_sealed
class SomeCubit extends Cubit<ExampleState> {
  SomeCubit()
      : super(
          const $ExampleState(),
        );
}

class ExampleState {
  const ExampleState();
}

class $ExampleState extends ExampleState {
  const $ExampleState();
}
