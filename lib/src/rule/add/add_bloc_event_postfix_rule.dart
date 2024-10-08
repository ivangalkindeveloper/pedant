import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart' as error;
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc.dart';

class AddBlocEventPostfixRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocEventPostfix == false) {
      return;
    }

    ruleList.add(
      AddBlocEventPostfixRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocEventPostfixRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_event_postfix",
            problemMessage: "Pedant: Add Bloc Event postfix.",
            correctionMessage: "Please add postfix 'Event' to this Bloc Event.",
            errorSeverity: error.ErrorSeverity.ERROR,
          ),
        );

  final int priority;

  @override
  void run(
    CustomLintResolver resolver,
    ErrorReporter reporter,
    CustomLintContext context,
  ) =>
      context.addBlocEvent(
        (
          ClassElement blocElement,
          ClassElement eventElement,
        ) {
          if (eventElement.displayName.endsWith(
                "Event",
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
