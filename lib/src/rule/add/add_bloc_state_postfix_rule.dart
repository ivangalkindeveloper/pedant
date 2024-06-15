import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';

import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';

class AddBlocStatePostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocStatePostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocStatePostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocStatePostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_state_postfix",
            problemMessage: "Add BLoC State postfix",
            correctionMessage: "Please add postfix 'State' to this BLoC State.",
            errorSeverity: ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addBlocState(
        (
          ClassElement blocElement,
          ClassElement stateElement,
        ) {
          if (stateElement.displayName.endsWith(
                "State",
              ) ==
              true) {
            return;
          }

          reporter.atElement(
            blocElement,
            this.code,
          );
        },
      );
}
