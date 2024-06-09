import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/error/error.dart';
import 'package:analyzer/error/listener.dart';
import 'package:custom_lint_builder/custom_lint_builder.dart';
import 'package:pedant/src/core/config/config.dart';
import 'package:pedant/src/utility/extension/add_bloc_event_element.dart';

class AddBlocEventSealedRule extends DartLintRule {
  static void combine({
    required Config config,
    required List<LintRule> ruleList,
  }) {
    if (config.addBlocEventSealed == false) {
      return;
    }

    ruleList.add(
      AddBlocEventSealedRule(
        priority: config.priority,
      ),
    );
  }

  const AddBlocEventSealedRule({
    required this.priority,
  }) : super(
          code: const LintCode(
            name: "add_bloc_event_sealed",
            problemMessage: "Add BLoC Event class sealed keyword",
            correctionMessage:
                "Please add 'sealed' keyword base Event class of this BLoC.",
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
      context.addBlocEventElement(
        (
          ClassElement blocElement,
          ClassElement eventElement,
        ) {
          if (eventElement.isSealed == true) {
            return;
          }

          reporter.atElement(
            blocElement,
            this.code,
          );
        },
      );
}
