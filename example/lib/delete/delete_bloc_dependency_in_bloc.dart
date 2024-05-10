// import 'package:bloc/bloc.dart';

// class Example1Bloc extends Bloc<Example1Event, Example1State> {
//   Example1Bloc()
//       : super(
//           const Example1Initial(),
//         ) {
//     on<Example1Event>(
//       (
//         event,
//         emit,
//       ) {},
//     );
//   }
// }

// sealed class Example1Event {
//   const Example1Event();
// }

// sealed class Example1State {
//   const Example1State();
// }

// final class Example1Initial extends Example1State {
//   const Example1Initial();
// }

// class Example2Bloc extends Bloc<Example2Event, Example2State> {
//   Example2Bloc(
//     this._bloc1, {
//     required Example1Bloc bloc2prop,
//   })  : this._bloc2 = bloc2prop,
//         super(
//           const Example2Initial(),
//         ) {
//     on<Example2Event>(
//       (
//         event,
//         emit,
//       ) {},
//     );
//   }

//   final Example1Bloc _bloc1;
//   final Example1Bloc _bloc2;
// }

// sealed class Example2Event {
//   const Example2Event();
// }

// sealed class Example2State {
//   const Example2State();
// }

// final class Example2Initial extends Example2State {
//   const Example2Initial();
// }
