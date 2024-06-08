import 'package:bloc/bloc.dart';
import 'package:example/add/add_bloc_event_sealed_event.dart';

class SomeBloc extends Bloc<BlocEvent, String> {
  SomeBloc() : super("") {}
}
