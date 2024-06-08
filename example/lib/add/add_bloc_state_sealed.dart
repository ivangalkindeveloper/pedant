import 'package:bloc/bloc.dart';
import 'package:example/add/add_bloc_state_sealed_state.dart';

class SomeBloc extends Bloc<String, BlocState> {
  SomeBloc()
      : super(
          const BlocState(),
        ) {}
}
