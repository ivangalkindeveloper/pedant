import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';
import 'package:pedant/src/utility/extension/add_cubit.dart';

class AddBlocCubitStatePostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocCubitStatePostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocCubitStatePostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocCubitStatePostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_cubit_state_postfix",
            problemMessage: "Add Bloc State postfix",
            correctionMessage: "Please add postfix 'State' to this Bloc State.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) {
    context.addBlocState(
      (
        ClassElement blocElement,
        ClassElement stateElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: blocElement,
        stateElement: stateElement,
      ),
    );
    context.addCubitState(
      (
        ClassElement cubitElement,
        ClassElement stateElement,
      ) =>
          _validate(
        reporter: reporter,
        classElement: cubitElement,
        stateElement: stateElement,
      ),
    );
  }

  void _validate({
    required ErrorReporter reporter,
    required ClassElement classElement,
    required ClassElement stateElement,
  }) {
    if (stateElement.displayName.endsWith(
          "State",
        ) ==
        true) {
      return;
    }

    reporter.atElement(
      classElement,
      this.code,
    );
  }
}
