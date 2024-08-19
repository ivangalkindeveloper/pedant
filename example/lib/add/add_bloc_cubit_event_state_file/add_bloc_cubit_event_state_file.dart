import 'package:bloc/bloc.dart';
import 'package:example/add/add_bloc_cubit_event_state_file/add_bloc_cubit_event_state_file_event.dart';
import 'package:example/add/add_bloc_cubit_event_state_file/add_bloc_cubit_event_state_file_state.dart';

// expect_lint: add_bloc_cubit_event_state_file
class ExampleBloc extends Bloc<ExampleEvent, ExampleState> {
  ExampleBloc()
      : super(
          const ExampleState$(),
        ) {
    on<ExampleEvent>(
      (
        ExampleEvent event,
        Emitter<ExampleState> emit,
      ) {},
    );
  }
}

// expect_lint: add_bloc_cubit_event_state_file
class ExampleCubit extends Cubit<ExampleState> {
  ExampleCubit()
      : super(
          const ExampleState$(),
        );
}
