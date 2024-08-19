import 'package:bloc/bloc.dart';

// expect_lint: add_bloc_event_sealed
class SomeBloc extends Bloc<ExampleEvent, String> {
  SomeBloc()
      : super(
          "",
        ) {}
}

class ExampleEvent {
  const ExampleEvent();
}

class $ExampleEvent extends ExampleEvent {
  const $ExampleEvent();
}
