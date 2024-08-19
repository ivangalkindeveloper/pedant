// ignore_for_file: unused_element

import 'package:flutter/widgets.dart';

SizedBox buildSizedBox() => const SizedBox();

class ExampleStateless extends StatelessWidget {
  const ExampleStateless({
    super.key,
  });

  // expect_lint: delete_widget_method
  SizedBox _buildBox() => const SizedBox();

  @override
  Widget build(
    BuildContext context,
  ) =>
      const SizedBox();
}

class ExampleStateful extends StatefulWidget {
  const ExampleStateful({
    super.key,
  });

  // expect_lint: delete_widget_method
  SizedBox _buildBox() => const SizedBox();

  @override
  State<ExampleStateful> createState() => _ExampleStatefulState();
}

class _ExampleStatefulState extends State<ExampleStateful> {
  _ExampleStatefulState();

  // expect_lint: delete_widget_method
  SizedBox _buildBox() => const SizedBox();

  @override
  Widget build(
    BuildContext context,
  ) =>
      const SizedBox();
}

class TextExample {
  const TextExample();

  SizedBox buildSizedBox() => const SizedBox();
}
