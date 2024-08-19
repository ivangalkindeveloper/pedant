import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

Widget sort({
  required List<String> strings,
// expect_lint: edit_arrow_function
}) {
  return const SizedBox(
    height: 12,
    width: 12,
  );
}

const int? count = 0;

class ExampleOneWidget extends StatelessWidget {
  const ExampleOneWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    if (count == null) {
      return const SizedBox();
    }

    if (count == 0) {
      return const SizedBox();
    }

    return const Column();
  }
}

class ExampleTwoWidget extends StatelessWidget {
  const ExampleTwoWidget({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    // expect_lint: edit_arrow_function
  ) {
    return BlocBuilder<SomeBloc, String>(
      builder: (
        BuildContext context,
        String state,
        // expect_lint: edit_arrow_function
      ) {
        return const SizedBox();
      },
    );
  }
}
