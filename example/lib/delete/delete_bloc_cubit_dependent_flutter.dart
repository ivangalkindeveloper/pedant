//ignore_for_file: unused_field, edit_constructor_public_named_parameter, delete_bloc_cubit_public_property

import 'package:flutter/material.dart';

import 'package:bloc/bloc.dart';

class Example1Bloc extends Bloc<String, String> {
  Example1Bloc(
    // expect_lint: delete_bloc_cubit_dependent_flutter
    this._animationController, {
    // expect_lint: delete_bloc_cubit_dependent_flutter
    required TextEditingController textEditingController,
    // expect_lint: delete_bloc_cubit_dependent_flutter
    required this.scrollController,
    // expect_lint: delete_bloc_cubit_dependent_flutter
  })  : this._textEditingController = textEditingController,
        super(
          "",
        );

  // expect_lint: delete_bloc_cubit_dependent_flutter
  final AnimationController _animationController;
  // expect_lint: delete_bloc_cubit_dependent_flutter
  final TextEditingController _textEditingController;
  // expect_lint: delete_bloc_cubit_dependent_flutter
  final ScrollController scrollController;
}
