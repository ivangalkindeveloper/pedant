import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc_state_element.dart';

class AddBlocStateSealedRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocStateSealed == false) {
      return;
    }

    ruleList.add(
      AddBlocStateSealedRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocStateSealedRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_state_sealed",
            problemMessage: "Add BLoC State class sealed keyword",
            correctionMessage:
                "Please add 'sealed' keyword base State class of this BLoC.",
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
      context.addBlocStateElement(
        (
          ClassElement blocElement,
          ClassElement stateElement,
        ) {
          if (stateElement.isSealed == true) {
            return;
          }

          reporter.atElement(
            blocElement,
            this.code,
          );
        },
      );
}
