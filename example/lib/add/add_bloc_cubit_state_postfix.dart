// ignore_for_file: add_class_prefix_by_keyword

import 'package:bloc/bloc.dart';

// expect_lint: add_bloc_cubit_state_postfix
class SomeBloc extends Bloc<String, ExampleStates> {
  SomeBloc()
      : super(
          const $ExampleStates(),
        ) {}
}

// expect_lint: add_bloc_cubit_state_postfix
class SomeCubit extends Cubit<ExampleStates> {
  SomeCubit()
      : super(
          const $ExampleStates(),
        );
}

sealed class ExampleStates {
  const ExampleStates();
}

class $ExampleStates extends ExampleStates {
  const $ExampleStates();
}
